# Coding Conventions

## File naming

| Kind | Pattern | Example |
|---|---|---|
| Page | `<feature>_page.dart` (`@RoutePage`, route becomes `<Feature>Route`) | `login_page.dart` |
| Bloc triplet | `<feature>_bloc.dart`, `_event.dart`, `_state.dart` | `login_bloc.dart` |
| Use case | `<verb>_<noun>_use_case.dart` | `get_current_user_use_case.dart` |
| DTO | `<name>_request.dart` / `<name>_response.dart` | `login_response.dart` |
| Mapper | `<entity>_data_mapper.dart` | `user_data_mapper.dart` |
| Entity | `<name>.dart` (freezed) | `user.dart` |

## Lint & format

- Root `analysis_options.yaml` (flutter_lints + prefer_single_quotes,
  always_declare_return_types, directives_ordering, unawaited_futures); every package
  includes it. CI runs `flutter analyze --fatal-infos` — **infos fail the build**.
- `dart run melos run format` before every commit; generated files are excluded by being
  gitignored.

## Codegen

Never hand-edit `*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.config.dart`, or anything
under `generated/`. They are not committed; regenerate with
`dart run melos run force_build_<package>` or `dart run melos run gen`.

## Localization

- ARB files: `package/shared/lib/l10n/intl_en.arb` + `intl_hi.arb`. **Every key goes in
  both files.**
- Regenerate: `dart run melos run l10n`. Access: `S.of(context).keyName`.
- No hardcoded user-facing strings in widgets.

## Constants

- Endpoints -> `UrlConstants`; storage keys / header names -> `StringConstants`;
  build-time env -> `EnvConstants`. All in `package/shared/lib/src/constants/`.

## Imports

Order: Dart SDK -> Flutter -> third-party -> workspace packages -> relative
(enforced by `directives_ordering`). Within a package use relative imports for
package-internal files; use `package:` imports across packages.

## Git

- Branches: `feature/<slug>` (or `feature/<TICKET-ID>-<slug>`).
- Commits: imperative subject, reference the issue/ticket.
- PRs: one feature per PR; description includes what/why + test evidence; the PR
  template checklist mirrors the AI review rules.
