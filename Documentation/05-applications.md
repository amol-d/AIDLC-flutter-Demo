# Applications

Two separate applications prove the monorepo supports independent apps sharing packages.
**Change only the requested app unless behavior clearly belongs in a package.**

## app1 — full demo app (`com.example.app1`)

- **Screens:** Login (`/login`), Home (`/home`, guarded, initial route)
- **Auth:** dummyjson login; token persisted via `AppPreferences` (localStorage on web,
  so sessions survive refresh)
- **Navigation:** auto_route with path URLs on web (real slugs), `AuthGuard` redirecting
  unauthenticated users to login
- **Deeplinks:** `aidlc://app1/home`, `aidlc://app1/login` (app_links; Android
  intent-filter + iOS CFBundleURLTypes; Flutter built-in deeplinking disabled to avoid
  double handling)
- **Splash:** flutter_native_splash on Android + iOS (brand color, dark-mode aware)
- **Flavor badge:** visible DEV/PREPROD/PROD chip in the app bar

Test a deeplink on Android:
```sh
adb shell am start -a android.intent.action.VIEW -d "aidlc://app1/home" com.example.app1
```

## app2 — skeleton (`com.example.app2`)

Single page showing the localized app name and current flavor. Depends only on
`package/shared`. It exists to demonstrate that:
- Melos scripts, analysis, tests, and CI scale to multiple apps
- Shared l10n/constants are consumable without the domain/data stack

Use app2 as the starting point when the AIDLC flow is asked to "create a new app".
