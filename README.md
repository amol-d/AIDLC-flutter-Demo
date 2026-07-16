# AIDLC-Demo

**AI-Driven Development Lifecycle, demonstrated end to end.** State a requirement — a
PRD, a GitHub issue, a JIRA ticket, or a one-line `@claude` comment — and an LLM agent
implements it, tests it, gets it reviewed, and ships it through DEV → PREPROD → PROD.

The vehicle is a production-shaped **fvm + Melos Flutter monorepo** with clean
architecture: two apps, three shared packages, codegen, localization (en/hi), flavors,
native splash, deeplinks, web slugs, and tests at every layer.

## The lifecycle

```
  PRD / issue / JIRA / Slack / prompt
                │  @claude mention
                ▼
   ┌─ claude.yml ──────────────┐     AI implements the feature following
   │  plan → code → test → PR  │     .claude/skills/feature-development
   └────────────┬──────────────┘
                ▼
   ci.yml (analyze • tests • builds)  +  claude-code-review.yml (AI review)
                │ merge
                ▼
   dev ──PR──► preprod ──PR──► main
    │             │              │
 deploy DEV   deploy PREPROD  deploy PROD     (Firebase Hosting + App Distribution)
```

## Quick start (local)

```sh
git clone git@github.com:amol-d/AIDLC-Demo.git && cd AIDLC-Demo
fvm install && fvm use 3.35.7
dart pub get && dart run melos bootstrap
dart run melos run gen                # generated files are not committed

cd app/app1
fvm flutter run -d chrome --dart-define FLAVOR=dev
```

Sign in with **emilys / emilyspass** (live round-trip against the public dummyjson API,
through the full use-case → repository → DTO → mapper pipeline).

## Try the AI lifecycle

1. Add the `ANTHROPIC_API_KEY` secret and install the Claude GitHub App —
   5 minutes, steps in [Documentation/setup/github-setup.md](Documentation/setup/github-setup.md).
2. Open an issue:
   > @claude Add a Settings screen with a language toggle (en/hi), reachable from Home.
3. Watch the agent open a PR, CI verify it, the AI reviewer comment on it — then merge to
   `dev` and see it deployed.

## Repository map

| Path | What |
|---|---|
| `app/app1` | Full demo app — login, home, guards, deeplinks (`aidlc://app1/...`), splash |
| `app/app2` | Minimal second app proving multi-app support |
| `package/domain` | Entities, use cases, `Repository` contract, navigation abstractions |
| `package/data` | DTOs, mappers, Dio clients, `RepositoryImpl`, preferences |
| `package/shared` | Constants, exceptions, `Result`, l10n, `Flavor` |
| `.claude/skills/` | Agent skills: feature-development, code-review, deploy, jira-ticket |
| `.github/workflows/` | CI, @claude dev agent, AI review, per-env deploys |
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
