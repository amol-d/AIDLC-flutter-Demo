import 'app_route_info.dart';

/// Navigation abstraction so blocs never touch the router directly.
/// Implemented per app (AppNavigatorImpl) on top of auto_route.
abstract class AppNavigator {
  Future<void> push(AppRouteInfo route);

  /// Replaces the entire stack with [route] (used after login/logout).
  Future<void> replaceAll(AppRouteInfo route);

  Future<bool> pop();
}
