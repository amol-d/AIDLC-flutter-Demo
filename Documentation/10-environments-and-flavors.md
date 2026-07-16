# Environments & Flavors

Three environments matching the branch strategy:

| Flavor | Branch | Badge | Hosting target |
|---|---|---|---|
| `dev` | `dev` | DEV (green) | app1-dev |
| `preprod` | `preprod` | PREPROD (orange) | app1-preprod |
| `prod` | `main` | PROD (red) | app1-prod |

## Mechanism: dart-define only

The flavor is a compile-time constant:

```sh
fvm flutter run --dart-define FLAVOR=preprod
fvm flutter build web --release --dart-define FLAVOR=prod
```

- `Flavor` enum + `EnvConstants.flavor` in `package/shared` (defaults to `dev`).
- `UrlConstants.authBaseUrl` switches per flavor (all three point at dummyjson in the
  demo; replace the switch arms for a real backend).
- The UI shows a `FlavorBadge` so every build is visually identifiable.
- Single application id per app (`com.example.app1`), no Gradle productFlavors or Xcode
  schemes — deliberately, to keep CI simple and portable.

## Extension points

- Real per-env backends: change only `UrlConstants`.
- Per-env secrets at build time: add more `--dart-define`s and read them in
  `EnvConstants`.
- Native flavor separation (separate app ids/icons per env): introduce
  `flutter_flavorizr` later; nothing in the codebase assumes its absence beyond the build
  commands.
