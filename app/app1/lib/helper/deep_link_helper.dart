import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

/// Listens for custom-scheme deeplinks (`aidlc://app1/...`) and maps them
/// to router-agnostic routes. Guards still run, so a deeplink to /home while
/// logged out lands on /login.
@lazySingleton
class DeepLinkHelper {
  DeepLinkHelper(this._appNavigator);

  final AppNavigator _appNavigator;
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  void listen() {
    _subscription ??= _appLinks.uriLinkStream.listen(handleUri);
  }

  void handleUri(Uri uri) {
    final route = mapUriToRoute(uri);
    if (route != null) {
      unawaited(_appNavigator.push(route));
    }
  }

  AppRouteInfo? mapUriToRoute(Uri uri) => switch (uri.path) {
    '/home' => const AppRouteInfo.home(),
    '/login' => const AppRouteInfo.login(),
    '/settings' => const AppRouteInfo.settings(),
    _ => null,
  };

  void dispose() {
    unawaited(_subscription?.cancel());
    _subscription = null;
  }
}
