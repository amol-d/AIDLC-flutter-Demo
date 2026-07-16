# Dependency Injection

**get_it + injectable.** Every package declares its own injectables and exposes one init
function in `lib/src/di/di.dart` (app: `lib/di/di.dart`); `injectable_generator` produces
the matching `di.config.dart` (not committed — regenerate with melos).

## Boot order (strict)

`AppInitializer` (`app/app1/lib/config/app_initializer.dart`) wires everything before
`runApp`:

```dart
configureSharedInjection(getIt);        // shared: exception mapper, ...
await configureDataInjection(getIt);    // data: async (pre-resolves SharedPreferences)
configureDomainInjection(getIt);        // domain: use cases
configureAppInjection(getIt);           // app: blocs, router, navigator, helpers
```

Lower layers must register first — a use case resolving `Repository` needs data's
registration to exist.

## Annotation conventions

| What | Annotation |
|---|---|
| Use cases, blocs, guards, mappers | `@Injectable()` / `@injectable` (new instance per resolve) |
| Repository implementation | `@LazySingleton(as: Repository)` |
| API service, clients, preferences, router, helpers | `@lazySingleton` |
| Interface binding | `@LazySingleton(as: AppNavigator)` |
| Async prerequisites | `@module` + `@preResolve` (see `DataModule.sharedPreferences`) |

## Adding a dependency

1. Annotate the class following the table above.
2. Run codegen for that package: `dart run melos run force_build_<package>`.
3. Constructor-inject it where needed — never call `GetIt.I` inside domain/data classes.
   (Pages resolving their bloc via `GetIt.I<XBloc>()` is the one sanctioned service-locator
   use.)

## Tests

`BaseBloc` dependencies are constructor-injected, so bloc tests pass mocks directly.
Widget tests that pump pages must register mock blocs in GetIt (`setUp`) and call
`getIt.reset()` in `tearDown` — see `app/app1/test/ui/login/login_page_test.dart`.
