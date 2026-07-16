---
name: deploy
description: Promote code through DEV -> PREPROD -> PROD environments. Use when asked to deploy, release, or promote a build.
---

# Deployment / promotion flow

Deployments are branch-driven. There is no manual deploy step — merging IS deploying.

| Branch | Environment | Workflow | Targets |
|---|---|---|---|
| `dev` | DEV | `.github/workflows/deploy-dev.yml` | Firebase Hosting (dev site) + App Distribution (FLAVOR=dev APK) |
| `preprod` | PREPROD | `.github/workflows/deploy-preprod.yml` | Firebase Hosting (preprod site) + App Distribution (FLAVOR=preprod APK) |
| `main` | PROD | `.github/workflows/deploy-prod.yml` | Firebase Hosting (prod site) + App Distribution (FLAVOR=prod APK) |

## To deploy to DEV
Merge the feature PR into `dev` (CI must be green).

## To promote DEV -> PREPROD
```sh
gh pr create --base preprod --head dev --title "Promote dev to preprod" \
  --body "Promotion PR. Changes included: <list>"
```
Merge once CI passes. Same pattern for PREPROD -> PROD (`--base main --head preprod`).

## Rules

- Never push directly to `dev`/`preprod`/`main` — always PR.
- Promotion PRs must not contain new commits other than what came through the lower branch.
- A `workflow_dispatch` trigger exists on every deploy workflow for re-runs.
- Deploy jobs are skipped (not failed) when Firebase secrets are absent; see
  `Documentation/setup/firebase-setup.md` to wire them.
- After a PROD deploy, verify the hosted app loads /login, sign in with demo creds,
  and confirm the flavor badge says PROD.

## Rollback

Revert the merge commit on the affected branch (`git revert -m 1 <sha>`) and push via PR;
the deploy workflow redeploys the previous state.
