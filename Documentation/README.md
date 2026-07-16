# AIDLC-Demo — Documentation

Central documentation for the **AIDLC-Demo** monorepo: a Flutter workspace built to
showcase an **AI-Driven Development Lifecycle** — features arrive as PRDs, issues, or
tickets; an LLM implements and tests them; CI reviews and builds; merges deploy to
DEV / PREPROD / PROD.

## Index

| # | Document | Description |
|---|----------|-------------|
| 1 | [Project Overview](./01-project-overview.md) | What this repo demonstrates, tech stack |
| 2 | [Architecture](./02-architecture.md) | Clean architecture layers and data flow |
| 3 | [Getting Started](./03-getting-started.md) | Prerequisites, setup, first run |
| 4 | [Monorepo Structure](./04-monorepo-structure.md) | Folder layout, packages, naming |
| 5 | [Applications](./05-applications.md) | app1 vs app2 |
| 6 | [State Management](./06-state-management.md) | BLoC pattern, BaseBloc, runBlocCatching |
| 7 | [Navigation & Deeplinks](./07-navigation-and-deeplinks.md) | auto_route, guards, web slugs, aidlc:// |
| 8 | [Dependency Injection](./08-dependency-injection.md) | GetIt + Injectable, init order |
| 9 | [Networking & Data](./09-networking-and-data.md) | Dio clients, DTOs, mappers, preferences |
| 10 | [Environments & Flavors](./10-environments-and-flavors.md) | dev / preprod / prod |
| 11 | [Testing](./11-testing.md) | Test layers, conventions, commands |
| 12 | [AIDLC Automation](./12-aidlc-automation.md) | @claude workflows, skills, review bot |
| 13 | [CI/CD & Deployment](./13-ci-cd-and-deployment.md) | Pipelines, Firebase Hosting/App Distribution |
| 14 | [Coding Conventions](./14-coding-conventions.md) | Naming, codegen, linting |

Setup guides: [GitHub setup](./setup/github-setup.md) ·
[Firebase setup](./setup/firebase-setup.md) ·
[JIRA / Slack / Figma integrations](./setup/integrations-jira-slack-figma.md)

## Quick start

```sh
fvm use 3.35.7
dart pub get
dart run melos bootstrap
dart run melos run gen        # generated files are not committed
cd app/app1 && fvm flutter run -d chrome --dart-define FLAVOR=dev
# demo login: emilys / emilyspass
```
