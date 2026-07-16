import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../authguard.dart';
import 'app_router.gr.dart';

/// Route table. Paths double as web slugs and deeplink paths
/// (https://host/home, aidlc://app1/home).
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
@LazySingleton()
class AppRouter extends RootStackRouter {
  AppRouter(this._authGuard);

  final AuthGuard _authGuard;

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
      initial: true,
      guards: [_authGuard],
    ),
    AutoRoute(
      page: SettingsRoute.page,
      path: '/settings',
      guards: [_authGuard],
    ),
    RedirectRoute(path: '*', redirectTo: '/home'),
  ];
}
