# Testing

## Commands

```sh
dart run melos run test:unit          # all packages with tests
cd package/data && fvm flutter test   # focused package run
fvm flutter test test/ui/login        # focused directory
```

Every package declares `flutter_test` in dev_dependencies so the melos filter includes it.
Test files mirror source paths: `lib/foo/bar.dart` -> `test/foo/bar_test.dart`.

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
