# CLAUDE.md — AIDLC-flutter-Demo

Guidance for Claude (and Claude Code GitHub workflows) working in this repository.

## What this repo is

An fvm-managed Flutter monorepo orchestrated with **Melos**, demonstrating an AI-Driven
Development Lifecycle (AIDLC): features arrive as PRDs/issues/tickets, an LLM implements
them, CI reviews/tests/builds, and merges deploy to DEV / PREPROD / PROD.

- Applications live in `app/` (`app1` = full demo app, `app2` = minimal skeleton).
- Reusable packages live in `package/` (`shared`, `domain`, `data`).
- Flutter is pinned via fvm (`.fvmrc`); Melos is pinned in the root `pubspec.yaml`.

## Commands (always from repo root)

```sh
dart pub get                    # once, resolves the pinned melos
dart run melos bootstrap        # link + pub get all packages
dart run melos run gen          # l10n + build_runner everywhere (REQUIRED after clone)
dart run melos run analyze      # flutter analyze --fatal-infos, all packages
dart run melos run test:unit    # all tests
dart run melos run format       # dart format
dart run melos run l10n         # regenerate S class from ARB files
dart run melos run force_build_shared|force_build_domain|force_build_data|force_build_app
```

Run an app: `cd app/app1 && fvm flutter run -d chrome --dart-define FLAVOR=dev` (web).
Android/iOS use native flavors: `fvm flutter run --flavor dev` (app ids:
dev `com.example.app1.dev`, preprod `com.example.app1.preprod`, prod `com.example.app1`;
regenerate native config with `dart run flutter_flavorizr -f` after editing the
`flavorizr:` section in `app/app1/pubspec.yaml`).

**Generated files (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.config.dart`, l10n output)
are NOT committed.** Run `dart run melos run gen` after cloning and after changing any
annotated declaration. Never hand-edit generated files.

## Architecture rules (non-negotiable)

Dependency direction: `app -> domain, data, shared`; `data -> domain, shared`;
`domain -> shared`. **`domain` must never import `data`.** Apps never import each other.

API-backed feature flow:

```
Bloc/UI -> use case -> Repository contract -> RepositoryImpl -> AppApiService -> DTO -> mapper -> entity
```

| Piece | Location |
|---|---|
| Domain entities | `package/domain/lib/src/entity/` |
| Use cases | `package/domain/lib/src/usecase/` |
| Repository contract | `package/domain/lib/src/repository/repository.dart` |
| Response DTOs | `package/data/lib/src/repository/model/` |
| API service | `package/data/lib/src/repository/source/api/app_api_service.dart` |
| Data mappers | `package/data/lib/src/repository/source/api/mapper/` |
| Repository impl | `package/data/lib/src/repository/repository_impl.dart` |
| Endpoint constants | `package/shared/lib/src/constants/url_constants.dart` |

Conventions:
- Use `BaseFutureUseCase` for async work, `BaseSyncUseCase` for synchronous work.
  Validate inputs at the top of `buildUseCase` (throw `ValidationException`).
- Annotate injectables like their neighbors (`@Injectable()`, `@LazySingleton(as: ...)`).
  Each package has its own `di.dart`; init order is shared -> data -> domain -> app.
- DTOs keep transport names and nullable fields; map to non-null domain defaults in a
  `BaseDataMapper<Response, Model>` subclass.
- Blocs extend `BaseBloc`, call use cases (never `Repository` directly), and wrap work in
  `runBlocCatching`. Navigation goes through `AppNavigator` + `AppRouteInfo`, never
  `context.router` in blocs.
- Handle thrown `AppException`s AND business errors in 200 responses (see
  `RepositoryImpl.login` token check).
- Export new public symbols from `package/domain/lib/domain.dart` /
  `package/data/lib/data.dart` / `package/shared/lib/shared.dart`.
- User-facing strings go in `package/shared/lib/l10n/intl_*.arb` (en + hi), accessed via
  `S.of(context)`; keys/headers via `StringConstants`, endpoints via `UrlConstants`.

## Testing expectations

- Mapper/DTO tests for wire-shape edge cases (nulls, legacy keys) in `package/data/test/`.
- Use-case forwarding tests with mocktail `MockRepository` in `package/domain/test/`.
- Bloc tests with `bloc_test` + mocked use cases in `app/*/test/`.
- Pages resolve blocs from GetIt: register mocks in `setUp`, `getIt.reset()` in `tearDown`.
- Run the affected package's tests first, then `dart run melos run test:unit`.

## Git / PR flow

Branches: `feature/*` -> `dev` -> `preprod` -> `main` (prod). Merges to dev/preprod/main
trigger the corresponding deploy workflow. Keep PRs scoped to one feature; change only the
requested app unless behavior clearly belongs in a package.

**Promotion gate:** after a feature is committed and tested on its `feature/*` branch,
ASK THE USER before creating the PR to `dev`. After it lands on dev and tests pass, ASK
before the promotion PR to `preprod`; same again for `main`. One approval covers one
promotion only — never chain them automatically.

**Version bump:** when raising a `feature/*` -> `dev` PR, bump app1's **minor** version in
`app/app1/pubspec.yaml` as the last change before committing — minor +1, patch -> 0, build
+1 (`1.0.0+1` -> `1.1.0+2`). Docs/CI/tooling-only PRs that change no app behaviour may skip it.

Before pushing: `dart run melos run format && dart run melos run analyze && dart run melos run test:unit`.

## Safety

- Never commit secrets, tokens, env values, or real Firebase config files.
- Preserve interceptor, auth-client, response-mapper, and exception-mapping behavior.
- Do not silently accept uncertain API shapes — confirm the contract or write tolerant
  parsing with tests (see `LoginResponse.effectiveAccessToken`).

More detail: `Documentation/` (architecture, testing, CI/CD, AIDLC automation).
