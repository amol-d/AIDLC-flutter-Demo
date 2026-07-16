import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import 'mapper/app_route_info_mapper.dart';
import 'routes/app_router.dart';

@LazySingleton(as: AppNavigator)
class AppNavigatorImpl implements AppNavigator {
  const AppNavigatorImpl(this._appRouter, this._routeInfoMapper);

  final AppRouter _appRouter;
  final AppRouteInfoMapper _routeInfoMapper;

  @override
  Future<void> push(AppRouteInfo route) =>
      _appRouter.push(_routeInfoMapper.map(route));

  @override
  Future<void> replaceAll(AppRouteInfo route) =>
      _appRouter.replaceAll([_routeInfoMapper.map(route)]);

  @override
  Future<bool> pop() => _appRouter.maybePop();
}
