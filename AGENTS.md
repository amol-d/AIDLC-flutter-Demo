# AGENTS.md — AIDLC-Demo

Instructions for any AI coding agent working in this repository. (Claude-specific
workflows also read `CLAUDE.md`, which carries the same rules.)

## Setup

```sh
dart pub get
dart run melos bootstrap
dart run melos run gen        # REQUIRED: generated files are not committed
```

Flutter is pinned via fvm (`.fvmrc` -> 3.35.7). Prefer `fvm flutter ...` or the melos
scripts, which use `.fvm/flutter_sdk` automatically.

## Verify before finishing any change

```sh
dart run melos run format
dart run melos run analyze      # must be clean (fatal infos)
dart run melos run test:unit    # must pass
```

If you changed Freezed/JSON/injectable/auto_route annotations, regenerate only the
affected package first: `dart run melos run force_build_<shared|domain|data|app>`.
If you changed `.arb` files: `dart run melos run l10n`.

## Layout and layer rules

- `app/app1` (full app), `app/app2` (skeleton) — separate applications; never import one
  from the other. Change only the requested app unless shared behavior belongs in a package.
- `package/shared` (constants, exceptions, Result, l10n) <- `package/domain` (entities,
  use cases, Repository contract, navigation abstractions) <- `package/data`
  (DTOs, mappers, API clients, RepositoryImpl).
- **`domain` must never import `data`.** Blocs call use cases, never `Repository` directly.

## Adding an API-backed feature (recipe)

1. Endpoint constant -> `package/shared/lib/src/constants/url_constants.dart`
2. Entity -> `package/domain/lib/src/entity/` (Freezed, non-null defaults)
3. Contract method -> `package/domain/lib/src/repository/repository.dart`
4. Use case -> `package/domain/lib/src/usecase/<feature>/` (`BaseFutureUseCase`,
   `@Injectable()`, Freezed Input/Output, validate inputs first)
5. DTO -> `package/data/lib/src/repository/model/<feature>/` (json_serializable,
   nullable fields, transport names)
6. Mapper -> `package/data/lib/src/repository/source/api/mapper/`
   (`BaseDataMapper<Response, Model>`, null-safe defaults)
7. API method -> `package/data/lib/src/repository/source/api/app_api_service.dart`
8. Implement in `package/data/lib/src/repository/repository_impl.dart`
9. Bloc + page -> `app/app1/lib/ui/<feature>/` (extend `BaseBloc`, use
   `runBlocCatching`, navigate via `AppNavigator`)
10. Export new public symbols from the package barrel files; add tests at every layer
    (mapper wire-shape, use-case forwarding, bloc states); run the verify commands.

Copy the auth feature end-to-end as the reference implementation.

## Git

Branch from `dev` as `feature/<slug>`; PR back into `dev`. Promotions: `dev -> preprod ->
main`. Merges deploy automatically (Firebase Hosting + App Distribution). Never commit
secrets or generated files.
