---
name: code-review
description: Review a PR or diff against AIDLC-flutter-Demo architecture and quality rules. Use for any code review request in this repository.
---

# Code review checklist

Review in this order; report findings most-severe first with file:line references.

## 1. Layer violations (blockers)

- `package/domain` importing `package/data` or any `dio`/`shared_preferences` transport type.
- A bloc calling `Repository` (or `RepositoryImpl`/`AppApiService`) directly instead of a use case.
- One app importing the other (`app1` <-> `app2`).
- Navigation via `context.router` inside a bloc (must use `AppNavigator` + `AppRouteInfo`).
- Business logic in widgets that belongs in a bloc/use case.

## 2. Data correctness

- New DTO fields non-nullable? (Wire fields must be nullable; defaults live in mappers.)
- Mapper missing null-safe defaults, or entity exposing nullable fields without need.
- 200-with-error-body cases handled (business errors are not only thrown exceptions).
- Hand-edits to `*.g.dart` / `*.freezed.dart` / `*.gr.dart` / `*.config.dart` (reject —
  these are not even committed).

## 3. Tests

- New DTO without a wire-shape test (including missing-field tolerance).
- New use case without a forwarding/validation test.
- New bloc without success + failure `bloc_test` coverage.

## 4. Conventions

- Strings hardcoded in widgets instead of `S.of(context)` + both ARB files updated.
- Endpoints inline instead of `UrlConstants`; magic keys instead of `StringConstants`.
- Injectable annotation missing or inconsistent with neighbors.
- New public symbol not exported from the package barrel.
- Naming: `*_page.dart`, `*_bloc.dart`, `*_use_case.dart`, `*_data_mapper.dart`.

## 5. Safety

- Secrets, tokens, or real Firebase config committed.
- Logging of request/response bodies or credentials.
- Interceptor/auth/exception-mapping behavior changed without justification.

Verify claims by reading the code, not the PR description. If CI hasn't run, state that
analyze/test results are unverified.
