# Project Overview

AIDLC-flutter-Demo is a working demonstration of an **AI-Driven Development Lifecycle**:

1. A human (or external tool) states a requirement — PRD/BRD text, a GitHub issue, a JIRA
   ticket, or a plain `@claude` comment.
2. An LLM agent (Claude Code via GitHub Actions) plans, implements, and tests the feature
   following this repo's clean-architecture conventions, then raises a PR.
3. An automated AI review checks every PR for layer violations, missing tests, and safety
   issues; classic CI runs analyze/tests/builds.
4. Merging deploys: `dev` → DEV, `preprod` → PREPROD, `main` → PROD (Flutter web to
   Firebase Hosting, Android APK to Firebase App Distribution).

The vehicle is a realistic, production-shaped Flutter monorepo — not a toy: two apps,
three shared packages, codegen, localization, flavors, deeplinks, and tests at every layer.

## Tech stack

| Area | Choice |
|---|---|
| SDK | Flutter 3.35.7 (Dart 3.9.2), pinned via **fvm** (`.fvmrc`) |
| Workspace | **Melos** 6.x (pinned in root `pubspec.yaml`, classic `melos.yaml`) |
| Architecture | Clean architecture: `app -> domain -> data`, shared kernel in `shared` |
| State | flutter_bloc + Freezed events/states |
| Navigation | auto_route 9 (path URLs on web, guards, deeplinks via app_links) |
| DI | get_it + injectable (per-package `di.dart`) |
| HTTP | dio (client per API family, interceptor middleware) |
| Persistence | shared_preferences (localStorage on web) |
| l10n | intl_utils (`S` class), locales: en, hi |
| Codegen | build_runner: freezed, json_serializable, injectable, auto_route |
| Testing | flutter_test, mocktail, bloc_test |
| CI/CD | GitHub Actions + anthropics/claude-code-action + Firebase |

## Demo feature

The seeded feature is authentication against the public `dummyjson.com` API:
login (`POST /auth/login`) and profile (`GET /auth/me`) with token persistence,
exercising the full flow — bloc → use case → repository → API service → DTO → mapper →
entity. Demo credentials: `emilys` / `emilyspass`.
