# AIDLC-flutter-Demo

**AI-Driven Development Lifecycle, demonstrated end to end.** State a requirement — a
PRD, a GitHub issue, a JIRA ticket, or a one-line `@claude` comment — and an LLM agent
implements it, tests it, gets it reviewed, and ships it through DEV → PREPROD → PROD.

The vehicle is a production-shaped **fvm + Melos Flutter monorepo** with clean
architecture: two apps, three shared packages, codegen, localization (en/hi) with an
in-app language toggle, native flavors, native splash, deeplinks, web slugs, and tests at
every layer.

## The lifecycle

```
  PRD / issue / JIRA / Slack / prompt
                │  @codex mention (OpenAI; @claude optional)
                ▼
   ┌─ codex.yml ───────────────┐     AI implements the feature following
   │  plan → code → test → PR  │     AGENTS.md + .claude/skills/feature-development
   └────────────┬──────────────┘
                ▼
   ci.yml (analyze • tests • builds)  +  openai-code-review.yml (AI review)
                │ merge (human-approved at every stage)
                ▼
   dev ──PR──► preprod ──PR──► main
    │             │              │
 deploy DEV   deploy PREPROD  deploy PROD     (Firebase Hosting + App Distribution)
```

## Quick start (local)

```sh
git clone git@github.com:amol-d/AIDLC-flutter-Demo.git && cd AIDLC-flutter-Demo
fvm install && fvm use 3.35.7
dart pub get && dart run melos bootstrap
dart run melos run gen                # generated files are not committed

cd app/app1
fvm flutter run -d chrome --dart-define FLAVOR=dev
```

Sign in with **emilys / emilyspass** (live round-trip against the public dummyjson API,
through the full use-case → repository → DTO → mapper pipeline).

In Android Studio / IntelliJ, pick a ready-made run configuration instead — e.g.
`app1 dev (debug)` or `app2 prod (release)` — shared from `.idea/runConfigurations/`
(one per app × dev/preprod/prod × debug/profile/release). See
[Documentation/10-environments-and-flavors.md](Documentation/10-environments-and-flavors.md).

## Try the AI lifecycle

1. Add the `OPENAI_API_KEY` secret — 2 minutes, steps in
   [Documentation/setup/github-setup.md](Documentation/setup/github-setup.md).
   (`@claude` via `ANTHROPIC_API_KEY` is an optional second backend.)
2. Open an issue:
   > @codex Add a version label under the login button. Follow the feature-development skill.
3. Watch the agent open a PR into `dev`, the AI reviewer comment on it — then approve and
   merge to see it deployed.

## Repository map

| Path | What |
|---|---|
| `app/app1` | Full demo app — login, home, settings (live en/hi toggle), guards, deeplinks (`aidlc://app1/...`), splash, version label |
| `app/app2` | Minimal second app proving multi-app support |
| `package/domain` | Entities, use cases, `Repository` contract, navigation abstractions |
| `package/data` | DTOs, mappers, Dio clients, `RepositoryImpl`, preferences |
| `package/shared` | Constants, exceptions, `Result`, l10n, `Flavor` |
| `.claude/skills/` | Agent skills: feature-development, code-review, deploy, jira-ticket |
| `.github/workflows/` | CI, @codex dev agent (OpenAI), AI review, per-env deploys (+ optional @claude) |
| `.idea/runConfigurations/` | Shared Android Studio run configs — app1/app2 × dev/preprod/prod × debug/profile/release |
| `Documentation/` | Full docs — start at [Documentation/README.md](Documentation/README.md) |

## Branching

`feature/*` → `dev` (DEV) → `preprod` (PREPROD) → `main` (PROD). Merges deploy; promotions
are plain PRs between environment branches. Details:
[Documentation/13-ci-cd-and-deployment.md](Documentation/13-ci-cd-and-deployment.md).

## Commands

```sh
dart run melos run analyze     # static analysis (fatal infos)
dart run melos run test:unit   # all tests
dart run melos run format      # formatting
dart run melos run gen         # l10n + all build_runner codegen
```

Agent rules live in [CLAUDE.md](CLAUDE.md) / [AGENTS.md](AGENTS.md).
