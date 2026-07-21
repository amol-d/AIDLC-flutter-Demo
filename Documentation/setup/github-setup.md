# GitHub Setup

One-time configuration to activate the AIDLC automation and protect the branch flow.

## 1. Repository secrets

GitHub → repo → Settings → Secrets and variables → Actions → *New repository secret*:

| Secret | Required for | Where to get it |
|---|---|---|
| `OPENAI_API_KEY` | **@codex dev + AI review workflows (the active AI path)** | https://platform.openai.com/api-keys |
| `ANTHROPIC_API_KEY` | optional @claude workflows (skip cleanly without it) | https://console.anthropic.com → API Keys |
| `AIDLC_BOT_APP_ID` + `AIDLC_BOT_PRIVATE_KEY` | **CI + AI review to run on agent-opened PRs** (recommended; see §2b) | GitHub App you create |
| `AIDLC_BOT_TOKEN` | same, simpler alternative to the App | fine-grained PAT (see §2b) |
| `FIREBASE_SERVICE_ACCOUNT` | deploys | see [firebase-setup.md](./firebase-setup.md) |
| `FIREBASE_PROJECT_ID` | deploys | Firebase console |
| `FIREBASE_ANDROID_APP_ID_DEV` | APK distribution (com.example.app1.dev) | Firebase console → Android app |
| `FIREBASE_ANDROID_APP_ID_PREPROD` | APK distribution (com.example.app1.preprod) | Firebase console → Android app |
| `FIREBASE_ANDROID_APP_ID_PROD` | APK distribution (com.example.app1) | Firebase console → Android app |

Equivalent CLI (after `gh auth login`):

```sh
gh secret set OPENAI_API_KEY --body "<key>"
gh secret set ANTHROPIC_API_KEY --body "<key>"   # optional
gh secret set FIREBASE_SERVICE_ACCOUNT < service-account.json
gh secret set FIREBASE_PROJECT_ID --body "<project-id>"
gh secret set FIREBASE_ANDROID_APP_ID_DEV --body "1:1234567890:android:abc123"
gh secret set FIREBASE_ANDROID_APP_ID_PREPROD --body "1:1234567890:android:def456"
gh secret set FIREBASE_ANDROID_APP_ID_PROD --body "1:1234567890:android:ghi789"
```

## 2. (Optional) Install the Claude GitHub App

Only needed for the optional `@claude` path. Either run `/install-github-app` from a
local Claude Code session in this repo, or install manually:
https://github.com/apps/claude → *Install* → select `AIDLC-flutter-Demo`. The `@claude`
workflows only respond once the app is installed AND `ANTHROPIC_API_KEY` is set.
The `@codex` path needs no app install — just the `OPENAI_API_KEY` secret.

## 2b. Bot identity so CI runs on agent PRs (recommended)

By GitHub's anti-recursion rule, a PR opened with the default `GITHUB_TOKEN` does **not**
trigger `ci.yml` or the AI-review workflows — so the `@codex`/`@claude` loop stalls at
"PR opened" until a human re-runs CI. Give the agent a bot identity to close the loop.
The workflows pick it up automatically (App token → PAT → default fallback); no workflow
edit needed.

**Option A — GitHub App (preferred: short-lived tokens, least privilege, higher rate limits)**

1. Create the App: GitHub → Settings → Developer settings → GitHub Apps → *New GitHub App*.
   - Repository permissions: **Contents: Read & write**, **Pull requests: Read & write**,
     **Issues: Read & write**. No account/webhook needed.
2. *Generate a private key* (downloads a `.pem`); note the numeric **App ID**.
3. Install the App on this repo (App page → *Install App*).
4. Add the secrets:
   ```sh
   gh secret set AIDLC_BOT_APP_ID --body "<app-id>"
   gh secret set AIDLC_BOT_PRIVATE_KEY < private-key.pem
   ```

**Option B — fine-grained PAT (simpler, but user-owned and expires)**

1. GitHub → Settings → Developer settings → Fine-grained tokens → *Generate new token*,
   scoped to this repo with **Contents: RW**, **Pull requests: RW**, **Issues: RW**.
2. `gh secret set AIDLC_BOT_TOKEN --body "<token>"`

Leave all three unset to keep the current behaviour (PRs open, CI re-run manually).

## 3. Branch protection

Settings → Branches → *Add branch protection rule*, once per branch (`main`, `preprod`,
`dev`):

- Require a pull request before merging (1 approval recommended on `main`)
- Require status checks to pass: select **analyze-test** (from `ci.yml`)
- Block force pushes

CLI equivalent:

```sh
for BR in main preprod dev; do
  gh api -X PUT "repos/amol-d/AIDLC-flutter-Demo/branches/$BR/protection" \
    -F 'required_status_checks[strict]=true' \
    -F 'required_status_checks[contexts][]=analyze-test' \
    -F 'enforce_admins=false' \
    -F 'required_pull_request_reviews[required_approving_review_count]=1' \
    -F 'restrictions=null' \
    -F 'allow_force_pushes=false'
done
```

## 4. Smoke test

Open an issue containing: `@codex add a version label under the login button`.
The `codex.yml` workflow should start within a minute, push a
`feature/codex-issue-<N>` branch, open a PR into `dev`, and comment the PR link on the
issue. (Note: CI on that PR needs a manual re-run unless you configure a PAT — see
Documentation/12-aidlc-automation.md.)
