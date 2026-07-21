---
name: feature-development
description: Implement a new feature in the AIDLC-flutter-Demo monorepo following clean architecture. Use when asked to add a screen, API integration, or any product feature from a PRD, issue, or ticket.
---

# Feature development recipe

Follow this exact flow for any API-backed feature. The auth feature (login/home) is the
canonical reference — mirror its structure, naming, and tests.

## 1. Plan the slices

Identify: entity(ies), endpoint(s), use case(s), UI screen(s). Prefer extending a nearby
feature's structure over inventing a new one.

## 2. Implement bottom-up

| Step | File | Reference |
|---|---|---|
| Endpoint constant | `package/shared/lib/src/constants/url_constants.dart` | `loginPath` |
| Entity (Freezed, defaults) | `package/domain/lib/src/entity/<name>.dart` | `user.dart` |
| Contract method | `package/domain/lib/src/repository/repository.dart` | `login()` |
| Use case | `package/domain/lib/src/usecase/<feature>/<verb>_use_case.dart` | `login_use_case.dart` |
| DTO (nullable, wire names) | `package/data/lib/src/repository/model/<feature>/` | `login_response.dart` |
| Mapper (null-safe defaults) | `package/data/lib/src/repository/source/api/mapper/` | `user_data_mapper.dart` |
| API method | `.../source/api/app_api_service.dart` | `login()` |
| Repo impl | `package/data/lib/src/repository/repository_impl.dart` | `login()` |
| Bloc (BaseBloc + runBlocCatching) | `app/app1/lib/ui/<feature>/bloc/` | `login_bloc.dart` |
| Page (@RoutePage) | `app/app1/lib/ui/<feature>/<feature>_page.dart` | `login_page.dart` |
| Route | `app/app1/lib/navigation/routes/app_router.dart` + `AppRouteInfo` | `/login` |

Rules:
- Use cases: `BaseFutureUseCase` (async) / `BaseSyncUseCase` (sync), `@Injectable()`,
  Freezed Input/Output, validate inputs first (throw `ValidationException`).
- DTOs keep transport names and nullable fields; mappers produce non-null entities.
- New user-facing strings: add to `package/shared/lib/l10n/intl_en.arb` AND `intl_hi.arb`.
- Export new public symbols from `domain.dart` / `data.dart` / `shared.dart` barrels.
- Navigation from blocs only via `AppNavigator` + `AppRouteInfo`.

## 3. Generate + verify

```sh
dart run melos run l10n                 # if ARB changed
dart run melos run force_build_domain   # per changed package
dart run melos run force_build_data
dart run melos run force_build_app
dart run melos run format
dart run melos run analyze
dart run melos run test:unit
```

## 4. Tests (required, every layer touched)

- Wire-shape test for each new DTO (missing fields, legacy keys) — `package/data/test/model/`
- Mapper null-tolerance test — `package/data/test/mapper/`
- Use-case forwarding/validation test — `package/domain/test/usecase/`
- Bloc test (success + failure paths) — `app/app1/test/ui/<feature>/`

## 5. Bump the version

Once the feature is implemented, generated, formatted, analyzed, and tested (all green),
**bump the app version before committing** — this is the last change and rides in the same
feature -> dev PR.

In `app/app1/pubspec.yaml` (the app being released), bump the **minor** segment by 1,
reset patch to 0, and increment the build number:

```
version: MAJOR.MINOR.PATCH+BUILD  ->  MAJOR.(MINOR+1).0+(BUILD+1)
# e.g. 1.0.0+1 -> 1.1.0+2, then 1.1.0+2 -> 1.2.0+3
```

The build number must strictly increase (Android versionCode / iOS build). PRs that change
no app behaviour (docs, CI, tooling only) may skip the bump.

## 6. PR

Branch `feature/<slug>` from `dev`, PR into `dev`. Description: what/why, screens touched,
the version bump, and test evidence. Never commit generated files or secrets.
