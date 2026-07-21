# Testing

## Commands

```sh
dart run melos run test:unit          # unit + widget tests (golden excluded)
dart run melos run test:coverage      # same, with coverage/lcov.info
dart run melos run test:golden        # golden (pixel) tests only
cd package/data && fvm flutter test   # focused package run
fvm flutter test test/ui/login        # focused directory
```

Every package declares `flutter_test` in dev_dependencies so the melos filter includes it.
Test files mirror source paths: `lib/foo/bar.dart` -> `test/foo/bar_test.dart`.

## Test lanes (CI)

| Lane | What | Gate |
|---|---|---|
| `analyze-test` | analyze + unit/widget tests | required |
| `coverage` | `test:coverage`, fails under **65%** line coverage | required |
| `golden` | pixel goldens (e.g. `FlavorBadge`) via `@Tags(['golden'])` | advisory* |
| `integration-web` | `integration_test/app_test.dart` on Chrome (`flutter drive`) | advisory* |

\* **Advisory** = `continue-on-error`, so it can't block a merge. Goldens are platform-sensitive
(baselines are generated on macOS; a tolerant comparator in `app/app1/test/flutter_test_config.dart`
absorbs ~2% anti-aliasing drift). Regenerate with
`cd app/app1 && fvm flutter test --update-goldens --tags golden`.

**Firebase Test Lab** (real-device matrix for `integration_test`) is a documented follow-up:
add a `gcloud firebase test android run` job using the Firebase service account; the
integration test and driver (`app/app1/test_driver/integration_test.dart`) are already in place.

## What to test at each layer

| Layer | Test | Example |
|---|---|---|
| shared | Pure logic (Result, runCatching, Flavor parsing) | `package/shared/test/helper/run_catching_test.dart` |
| domain | Use-case forwarding + validation with mocktail `MockRepository` | `package/domain/test/usecase/auth/login_use_case_test.dart` |
| data | DTO wire shapes (missing fields, legacy keys), mapper null-tolerance, RepositoryImpl orchestration with mocked service/prefs | `package/data/test/model/login_response_test.dart` |
| app | Bloc success+failure paths (`bloc_test`), page widget smoke tests | `app/app1/test/ui/login/login_bloc_test.dart` |

## Conventions

- **mocktail** for mocks; call `registerFallbackValue` in `setUpAll` for custom argument
  types (freezed inputs, route infos).
- **bloc_test** for blocs: assert emitted state sequences AND verify use-case/navigator
  interactions.
- Widget tests pumping pages must provide localization delegates (`S.delegate` + the
  Global* delegates) and register mock blocs in GetIt (`getIt.reset()` in `tearDown`).
- Every new DTO needs a wire-shape test including the missing-field case; every tolerant
  parse (like the `token` fallback) needs an explicit test.
- A PR adding a use case, DTO, mapper, or bloc without matching tests fails AI review.
