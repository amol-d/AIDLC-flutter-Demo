# CI/CD & Deployment

## Branching strategy

```
feature/<slug>  ->  dev  ->  preprod  ->  main
     (PR)          (DEV)    (PREPROD)    (PROD)
```

- Feature branches cut from `dev`; PRs back into `dev`.
- Promotions are PRs between environment branches (`dev`->`preprod`, `preprod`->`main`).
- Never push directly to environment branches (enable branch protection — see
  [setup/github-setup.md](./setup/github-setup.md)).

## CI (`ci.yml`)

On every PR and push to dev/preprod/main:

1. **analyze-test** — Flutter 3.35.7 setup (composite action `.github/actions/flutter-setup`),
   `melos bootstrap`, `melos run gen`, `melos run analyze`, `melos run test:unit`.
2. **build-web** — release web builds of app1 + app2.
3. **build-android** — debug APK, only on PRs targeting preprod/main (slower lane).

## Deploys (`deploy-dev.yml`, `deploy-preprod.yml`, `deploy-prod.yml`)

On push to the matching branch (plus manual `workflow_dispatch`):

- **Web**: `flutter build web --release --dart-define FLAVOR=<env>` in `app/app1`, then
  `FirebaseExtended/action-hosting-deploy` to the env's hosting target (`app1-<env>`).
  `firebase.json` includes the SPA rewrite (`**` -> `/index.html`) required for slugs.
- **Android**: `flutter build apk --release --dart-define FLAVOR=<env>`, then Firebase
  App Distribution to the `testers` group with env-tagged release notes.

Both jobs first check that `FIREBASE_SERVICE_ACCOUNT` exists and **skip cleanly**
when Firebase isn't wired yet, keeping the pipeline green out of the box.

## Secrets

| Secret | Used by | Notes |
|---|---|---|
| `ANTHROPIC_API_KEY` | claude.yml, claude-code-review.yml | Enables the AI workflows |
| `OPENAI_API_KEY` | claude.yml (env) | Optional; for OpenAI-backed tooling/scripts |
| `FIREBASE_SERVICE_ACCOUNT` | deploy-*.yml | Service-account JSON |
| `FIREBASE_PROJECT_ID` | deploy-*.yml | Firebase project id |
| `FIREBASE_ANDROID_APP_ID` | deploy-*.yml | App Distribution app id (1 app id; env carried in release notes) |

## Versioning & rollback

App version lives in each app's `pubspec.yaml` (`version: x.y.z+build`). Roll back an
environment by reverting the merge commit on its branch (PR), which re-triggers the
deploy with the previous code.
