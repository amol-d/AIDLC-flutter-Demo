# GitHub Setup

One-time configuration to activate the AIDLC automation and protect the branch flow.

## 1. Repository secrets

GitHub → repo → Settings → Secrets and variables → Actions → *New repository secret*:

| Secret | Required for | Where to get it |
|---|---|---|
| `OPENAI_API_KEY` | **@codex dev + AI review workflows (the active AI path)** | https://platform.openai.com/api-keys |
| `ANTHROPIC_API_KEY` | optional @claude workflows (skip cleanly without it) | https://console.anthropic.com → API Keys |
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
