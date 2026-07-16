# Monorepo Structure

```
AIDLC-Demo/
├── app/                          # Applications only
│   ├── app1/                     # Full demo app (login, home, deeplinks, splash)
│   │   ├── lib/
│   │   │   ├── main.dart
│   │   │   ├── app/my_app.dart
│   │   │   ├── base/bloc/        # BaseBloc + runBlocCatching
│   │   │   ├── common_view/      # Reusable widgets (FlavorBadge)
│   │   │   ├── config/           # AppInitializer (DI boot order)
│   │   │   ├── di/               # App-level injectable init
│   │   │   ├── helper/           # DeepLinkHelper
│   │   │   ├── navigation/       # AppRouter, AuthGuard, AppNavigatorImpl, mapper
│   │   │   └── ui/<feature>/     # <feature>_page.dart + bloc/ triplet
│   │   ├── android/  ios/  web/  # Platform shells (incl. splash + deeplink config)
│   │   └── test/
│   └── app2/                     # Minimal skeleton (depends on shared only)
├── package/                      # Reusable packages only
│   ├── shared/                   # Constants, exceptions, Result, l10n, Flavor
│   ├── domain/                   # Entities, use cases, Repository contract, navigation
│   └── data/                     # DTOs, mappers, Dio clients, RepositoryImpl, prefs
├── Documentation/                # This documentation set
├── .claude/skills/               # Agent skills (feature-development, code-review, ...)
├── .github/workflows/            # CI, AI dev/review, deploys
├── melos.yaml                    # Workspace scripts
├── pubspec.yaml                  # Root (pins melos)
├── .fvmrc                        # Pins Flutter 3.35.7
├── firebase.json / .firebaserc   # Hosting targets + SPA rewrites
├── CLAUDE.md / AGENTS.md         # Agent instructions
└── analysis_options.yaml         # Root lints (packages include it)
```

## Package dependency graph

```
app1 -> domain, data, shared
app2 -> shared
data -> domain, shared
domain -> shared
```

## Barrel exports

Each package exposes exactly one public entry point; add new public symbols there:

- `package/shared/lib/shared.dart`
- `package/domain/lib/domain.dart`
- `package/data/lib/data.dart`

## Generated code (not committed)

`*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.config.dart`, and
`package/shared/lib/src/generated/` are gitignored. CI regenerates them on every run;
locally run `dart run melos run gen` after cloning or changing annotated code.
