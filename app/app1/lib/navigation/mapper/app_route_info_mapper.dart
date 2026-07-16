import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../routes/app_router.gr.dart';

/// Maps router-agnostic [AppRouteInfo] values onto concrete auto_route pages.
@lazySingleton
class AppRouteInfoMapper {
  const AppRouteInfoMapper();

  PageRouteInfo map(AppRouteInfo routeInfo) => routeInfo.when(
    login: () => const LoginRoute(),
    home: () => const HomeRoute(),
    settings: () => const SettingsRoute(),
  );
}
