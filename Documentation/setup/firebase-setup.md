# Firebase Setup (Hosting + App Distribution)

Deploy workflows are pre-wired and **skip cleanly until these secrets exist**, so do this
whenever you're ready.

## 1. Create the project & apps

1. https://console.firebase.google.com → *Add project* (e.g. `aidlc-demo`).
2. Add **three Android apps** — one per flavor's application id — and note each **App ID**
   (`1:...:android:...`) for the matching secret. (No google-services.json is needed for
   App Distribution-only usage.)

   | Package name | Secret |
   |---|---|
   | `com.example.app1.dev` | `FIREBASE_ANDROID_APP_ID_DEV` |
   | `com.example.app1.preprod` | `FIREBASE_ANDROID_APP_ID_PREPROD` |
   | `com.example.app1` | `FIREBASE_ANDROID_APP_ID_PROD` |

## 2. Hosting sites (one per environment)

```sh
npm i -g firebase-tools
firebase login
firebase use <project-id>

firebase hosting:sites:create aidlc-demo-app1-dev
firebase hosting:sites:create aidlc-demo-app1-preprod
firebase hosting:sites:create aidlc-demo-app1-prod
```

Then update `.firebaserc` target mappings if your site names differ from the defaults
committed there. `firebase.json` already contains the three targets with the SPA rewrite
(`**` → `/index.html`) required for `/login` and `/home` slugs.

## 3. App Distribution

Console → App Distribution → *Get started* for each of the three Android apps, and
create a tester group named **testers** (the workflows distribute to it).

## 4. Service account for CI

1. Console → Project settings → Service accounts → *Generate new private key*, or create
   a dedicated SA in Google Cloud IAM with roles: **Firebase Hosting Admin** +
   **Firebase App Distribution Admin**.
2. Save the JSON and add it as the `FIREBASE_SERVICE_ACCOUNT` repo secret (paste the
   whole JSON). Add `FIREBASE_PROJECT_ID` and the three
   `FIREBASE_ANDROID_APP_ID_{DEV,PREPROD,PROD}` secrets too.
3. **Never commit this JSON** — the `.gitignore` blocks `firebase-service-account*.json`
   as a safety net.

## 5. Verify

Push any commit to `dev` (or run *deploy-dev* via workflow_dispatch). The web build
should appear at `https://aidlc-demo-app1-dev.web.app` and the APK in App Distribution
with release notes `dev <sha>`.
