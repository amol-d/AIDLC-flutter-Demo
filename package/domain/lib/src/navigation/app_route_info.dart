import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_route_info.freezed.dart';

/// Router-agnostic description of an app destination. Blocs and use cases
/// navigate with these; the app layer maps them onto concrete routes.
@freezed
class AppRouteInfo with _$AppRouteInfo {
  const factory AppRouteInfo.login() = LoginRouteInfo;
  const factory AppRouteInfo.home() = HomeRouteInfo;
  const factory AppRouteInfo.settings() = SettingsRouteInfo;
}
