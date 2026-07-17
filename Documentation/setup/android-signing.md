# Android release signing

app1's `release` build type is wired to sign with an **upload keystore** you keep
locally. The wiring lives in
[`app/app1/android/app/build.gradle.kts`](../../app/app1/android/app/build.gradle.kts):
it reads `android/key.properties` and, when that file is absent (CI, fresh clones), falls
back to the debug key so release builds still succeed.

**Nothing secret is committed.** `key.properties`, `*.keystore`, and `*.jks` are all
git-ignored (see the repo `.gitignore`). Never add your keystore or passwords to git.

## One-time local setup

1. Create an upload keystore (skip if you already have one):

   ```sh
   keytool -genkey -v -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Create `app/app1/android/key.properties` (git-ignored) with your values:

   ```properties
   storePassword=<store password>
   keyPassword=<key password>
   keyAlias=upload
   storeFile=/absolute/path/to/upload-keystore.jks
   ```

   `storeFile` is resolved with Gradle's `file(...)`; an absolute path is simplest.

## Build a production release

```sh
cd app/app1
# App Bundle for the Play Store (preferred)
fvm flutter build appbundle --release --flavor prod --dart-define FLAVOR=prod
# or an installable APK
fvm flutter build apk --release --flavor prod --dart-define FLAVOR=prod
```

Outputs (flavor-suffixed):

| Artifact | Path |
|---|---|
| App Bundle | `build/app/outputs/bundle/prodRelease/app-prod-release.aab` |
| APK | `build/app/outputs/flutter-apk/app-prod-release.apk` |

## Verify it is signed with your key (not the debug key)

```sh
# APK
"$ANDROID_HOME"/build-tools/<version>/apksigner verify --print-certs \
  build/app/outputs/flutter-apk/app-prod-release.apk
# App Bundle
jarsigner -verify -verbose -certs build/app/outputs/bundle/prodRelease/app-prod-release.aab
```

The printed certificate should show your alias/fingerprint, not "Android Debug".

## Notes

- The signing config is on the `release` **build type**, so `dev`/`preprod`/`prod`
  release builds all use the upload key. To sign *only* `prod` with it, move
  `signingConfig` into the `prod` flavor block in `android/app/flavorizr.gradle.kts`.
## CI-driven prod signing

`deploy-prod.yml` signs the release APK from secrets — no keystore lives on the runner.
Its `Restore signing config from secrets` step base64-decodes the keystore into
`$RUNNER_TEMP` and writes `key.properties` before `flutter build`; the Gradle wiring then
signs `release` with the upload key. The step is guarded by a `signing` output on the
`check-secrets` job, so if the signing secrets are absent it skips and the build falls
back to the debug key.

Required repository secrets (Settings → Secrets and variables → Actions):

| Secret | Value |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | `base64 -i <keystore>.jks \| tr -d '\n'` output |
| `ANDROID_KEYSTORE_PASSWORD` | store password |
| `ANDROID_KEY_PASSWORD` | key password |
| `ANDROID_KEY_ALIAS` | key alias (e.g. `upload`) |

GitHub masks these in logs and wipes `$RUNNER_TEMP` when the job ends.
