# Setup — Firebase Crashlytics

The app wires Crashlytics **defensively** (`app/app1/lib/config/crash_reporter.dart`): it is
skipped on web (Crashlytics is mobile-only) and a **no-op until Firebase config is present**,
so builds and runtime stay green without any setup. Add the native config below to turn it on.

## 1. Register the apps + download config

In the Firebase console, add an Android app per flavor and an iOS app, then download config:

| Flavor | Android package | File |
|---|---|---|
| dev | `com.example.app1.dev` | `google-services.json` |
| preprod | `com.example.app1.preprod` | `google-services.json` |
| prod | `com.example.app1` | `google-services.json` |

Place `google-services.json` under `app/app1/android/app/src/<flavor>/` (or the app module
root for a single-flavor setup), and `GoogleService-Info.plist` in the iOS runner.
**These files are git-ignored — never commit them.**

## 2. Apply the Gradle plugins (Android)

`app/app1/android/settings.gradle.kts` — add to the plugins block:

```kotlin
id("com.google.gms.google-services") version "4.4.2" apply false
id("com.google.firebase.crashlytics") version "3.0.2" apply false
```

`app/app1/android/app/build.gradle.kts` — apply them:

```kotlin
plugins {
  id("com.google.gms.google-services")
  id("com.google.firebase.crashlytics")
}
```

## 3. iOS

Add `GoogleService-Info.plist` to the Runner target; run `pod install` in `ios/`.

## 4. Verify

`initCrashReporting()` calls `Firebase.initializeApp()`; with valid config it installs the
`FlutterError` + zone-error handlers. Force a test crash to confirm reports land in the
Firebase console.

> No config? The app runs exactly as before — crash reporting is simply inactive.
