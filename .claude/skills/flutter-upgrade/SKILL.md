---
name: flutter-upgrade
description: Upgrade the pinned Flutter SDK version via fvm across the monorepo. Use when asked to bump, update, or upgrade the Flutter or Dart version.
---

# Flutter SDK upgrade

`.fvmrc` is the single source of truth for the Flutter version — both local dev
(via fvm) and CI (`.github/actions/flutter-setup` reads `flutter-version-file: .fvmrc`)
follow it. So the version bump is **one edit**; the rest of this flow is making sure the
app still builds and runs flawlessly on the new SDK.

## 1. Set the version (source of truth)

```sh
fvm install <version>     # e.g. 3.38.0 — downloads the SDK
fvm use <version>         # rewrites .fvmrc and regenerates .fvm/* (config, symlink)
```

Never hand-edit the `.fvm/` files — `fvm use` regenerates them. CI needs no separate
change: it reads `.fvmrc` through the composite action.

## 2. Update SDK constraints if the bundled Dart changed

Check the Dart version the new SDK ships: `fvm dart --version`. If Dart's major/minor
moved, widen/raise the `sdk:` constraint; on a minor/major Flutter upgrade also raise the
`flutter:` floor in the three packages.

| File | Field to update |
|---|---|
| `.fvmrc` | `flutter` (done in step 1) |
| `package/{shared,domain,data}/pubspec.yaml` | `flutter: ">=…"` floor + `sdk:` |
| `pubspec.yaml`, `app/app1/pubspec.yaml`, `app/app2/pubspec.yaml` | `sdk:` only |

Keep the upper bound (`<4.0.0`) unless Dart 4 actually ships.

## 3. Re-resolve + regenerate

Generated files are not committed — regenerate them against the new SDK.

```sh
dart pub get
dart run melos bootstrap
dart run melos run gen        # l10n + build_runner everywhere
```

Only if a dependency breaks on the new SDK: `fvm flutter pub upgrade` (then re-run gen).
Do not upgrade deps unnecessarily — keep the upgrade diff to the SDK.

## 4. Static verify

```sh
dart run melos run format
dart run melos run analyze     # --fatal-infos: must be clean
dart run melos run test:unit   # must pass
```

Fix any new analyzer errors or deprecation warnings the SDK introduces — do not suppress
them.

## 5. Runtime verify — the app must work flawlessly on the new SDK

Static green is not enough. Prove the app builds and runs.

```sh
cd app/app1 && fvm flutter build web --dart-define FLAVOR=dev      # must succeed
fvm flutter run -d chrome --dart-define FLAVOR=dev                 # then smoke script below
fvm flutter build apk --debug --flavor dev --dart-define FLAVOR=dev # native toolchain sanity
cd ../app2 && fvm flutter build web --dart-define FLAVOR=dev       # skeleton builds too
```

Smoke script on the running app1 (web):

1. `/` → AuthGuard redirects to `/login`.
2. Sign in `emilys` / `emilyspass` → real dummyjson round-trip → `/home` shows avatar,
   name, email from `/auth/me`.
3. Hard-refresh `/home` → stays logged in (token in localStorage).
4. Logout → back to `/login`.
5. Wrong password → error banner, no navigation.
6. Flavor badge reads **DEV**.

If anything regresses, resolve it before proceeding — never ship a red upgrade.

## 6. Update the docs that name the version

The version string is repeated in prose. Update every occurrence to the new version
(and Dart version where shown):

- `README.md` (`fvm use …`)
- `AGENTS.md` (`.fvmrc -> <ver>`)
- `Documentation/README.md`, `Documentation/03-getting-started.md`
- `Documentation/01-project-overview.md` (Flutter + Dart), `Documentation/04-monorepo-structure.md`
- `Documentation/13-ci-cd-and-deployment.md`

`CLAUDE.md` references `.fvmrc` without a number — leave it.

## 7. PR

Branch `feature/flutter-upgrade-<version>` from `dev`, PR into `dev`. This is a **tooling**
change: **skip the app version-bump** (the docs/CI/tooling carve-out in the
`feature-development` skill). Describe the SDK/Dart version delta, any dep changes, and the
runtime-verify evidence. Ask the user before opening the PR, then promote through
`dev -> preprod -> main` per the [deploy](../deploy/SKILL.md) skill — one approval each,
never chained.
