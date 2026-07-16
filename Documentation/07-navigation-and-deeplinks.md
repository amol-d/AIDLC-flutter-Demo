# Navigation & Deeplinks

## Router

**auto_route 9.** Route table: `app/app1/lib/navigation/routes/app_router.dart`.

```dart
AutoRoute(page: LoginRoute.page, path: '/login'),
AutoRoute(page: HomeRoute.page, path: '/home', initial: true, guards: [_authGuard]),
RedirectRoute(path: '*', redirectTo: '/home'),
```

Paths double as **web slugs** (`usePathUrlStrategy()` in `main.dart` removes the `/#/`
fragment) and as **deeplink paths**. Pages are annotated `@RoutePage()`;
`melos run force_build_app` regenerates `app_router.gr.dart`.

## Domain abstraction

Blocs never touch the router. They use `AppNavigator` (contract in
`package/domain/lib/src/navigation/`) with router-agnostic `AppRouteInfo` values:

```
bloc -> AppNavigator.replaceAll(AppRouteInfo.home())
     -> AppNavigatorImpl -> AppRouteInfoMapper -> auto_route push/replaceAll
```

Adding a screen = add a case to the `AppRouteInfo` freezed union, map it in
`AppRouteInfoMapper`, and register the route in `AppRouter`.

## Auth guard

`AuthGuard` (`app/app1/lib/navigation/authguard.dart`) runs `CheckLoginStatusUseCase` on
every navigation into a guarded route — covering direct pushes, typed web URLs, and
deeplinks — and redirects to `/login` when no token is persisted.

## Deeplinks

- Scheme: `aidlc://app1/<path>` — e.g. `aidlc://app1/home`.
- Runtime links: `DeepLinkHelper` (`app/app1/lib/helper/deep_link_helper.dart`)
  subscribes to `AppLinks().uriLinkStream` (initial link included) and maps URI paths to
  `AppRouteInfo`s. Enabled on mobile only; web URLs go through the router directly.
- Native registration: Android intent-filter in `AndroidManifest.xml`; iOS
  `CFBundleURLTypes` in `Info.plist`. Flutter's built-in deeplink handling is explicitly
  disabled on both platforms (`flutter_deeplinking_enabled=false`,
  `FlutterDeepLinkingEnabled=false`) so app_links is the single owner.
- Hosting slugs: `firebase.json` rewrites `**` -> `/index.html` so a direct visit to
  `/home` loads the app instead of 404ing.

Test on Android:
```sh
adb shell am start -a android.intent.action.VIEW -d "aidlc://app1/home" com.example.app1
```
