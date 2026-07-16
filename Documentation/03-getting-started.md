# Getting Started

## Prerequisites

- [fvm](https://fvm.app) 4.x (`dart pub global activate fvm`)
- Dart/Flutter come via fvm — no system Flutter needed
- For Android builds: JDK 17+, Android SDK
- For iOS builds (optional): Xcode + CocoaPods on macOS

## Setup

```sh
git clone git@github.com:amol-d/AIDLC-Demo.git
cd AIDLC-Demo

fvm install            # installs Flutter 3.35.7 from .fvmrc
fvm use 3.35.7

dart pub get           # resolves the pinned melos
dart run melos bootstrap
dart run melos run gen # REQUIRED: l10n + build_runner (generated files are not committed)
```

## Run

```sh
# Web (fastest way to see the app)
cd app/app1
fvm flutter run -d chrome --dart-define FLAVOR=dev

# Android
fvm flutter run -d <device> --dart-define FLAVOR=dev

# app2 (skeleton)
cd app/app2 && fvm flutter run -d chrome --dart-define FLAVOR=dev
```

Sign in with the demo credentials: **emilys / emilyspass** (public dummyjson.com API).

## Everyday commands

```sh
dart run melos run analyze     # static analysis, fatal infos
dart run melos run test:unit   # all tests
dart run melos run format      # formatting
dart run melos run l10n        # regenerate S class after editing .arb files
dart run melos run force_build_<shared|domain|data|app>   # per-package codegen
dart run melos run gen         # everything (l10n + all codegen)
```

## Troubleshooting

- **"Missing *.g.dart / *.freezed.dart"** — run `dart run melos run gen`.
- **Melos version mismatch** — always invoke as `dart run melos ...`; the workspace pins
  melos 6.x in the root pubspec, and a globally activated melos 7/8 would otherwise apply
  different config rules.
- **Splash changes not applied** — `cd app/app1 && dart run flutter_native_splash:create`.
