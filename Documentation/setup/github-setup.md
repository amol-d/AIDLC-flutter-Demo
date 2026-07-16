# GitHub Setup

One-time configuration to activate the AIDLC automation and protect the branch flow.

## 1. Repository secrets

GitHub → repo → Settings → Secrets and variables → Actions → *New repository secret*:

| Secret | Required for | Where to get it |
|---|---|---|
| `ANTHROPIC_API_KEY` | @claude dev + AI review workflows | https://console.anthropic.com → API Keys |
| `OPENAI_API_KEY` | optional OpenAI-backed tooling | https://platform.openai.com/api-keys |
| `FIREBASE_SERVICE_ACCOUNT` | deploys | see [firebase-setup.md](./firebase-setup.md) |
| `FIREBASE_PROJECT_ID` | deploys | Firebase console |
| `FIREBASE_ANDROID_APP_ID` | APK distribution | Firebase console → Android app |

Equivalent CLI (after `gh auth login`):

```sh
gh secret set ANTHROPIC_API_KEY --body "<key>"
gh secret set OPENAI_API_KEY --body "<key>"
gh secret set FIREBASE_SERVICE_ACCOUNT < service-account.json
gh secret set FIREBASE_PROJECT_ID --body "<project-id>"
gh secret set FIREBASE_ANDROID_APP_ID --body "1:1234567890:android:abc123"
```

## 2. Install the Claude GitHub App

Either run `/install-github-app` from a local Claude Code session in this repo, or
install manually: https://github.com/apps/claude → *Install* → select `AIDLC-Demo`.
The `@claude` workflows only respond once the app is installed AND
`ANTHROPIC_API_KEY` is set.

## 3. Branch protection

Settings → Branches → *Add branch protection rule*, once per branch (`main`, `preprod`,
`dev`):

- Require a pull request before merging (1 approval recommended on `main`)
- Require status checks to pass: select **analyze-test** (from `ci.yml`)
- Block force pushes

CLI equivalent:

```sh
for BR in main preprod dev; do
  gh api -X PUT "repos/amol-d/AIDLC-Demo/branches/$BR/protection" \
    -F 'required_status_checks[strict]=true' \
    -F 'required_status_checks[contexts][]=analyze-test' \
    -F 'enforce_admins=false' \
    -F 'required_pull_request_reviews[required_approving_review_count]=1' \
    -F 'restrictions=null' \
    -F 'allow_force_pushes=false'
done
```

## 4. Smoke test

Open an issue containing: `@claude add a version label under the login button`.
The `claude.yml` workflow should start within a minute, push a `feature/*` branch, and
open a PR into `dev` with CI + AI review running on it.
