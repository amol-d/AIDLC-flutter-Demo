import '../model/flavor.dart';
import 'env_constants.dart';

/// Endpoint constants. Base URLs switch per flavor so each environment can
/// point at its own backend. The demo uses the public dummyjson API for all
/// three environments; replace the switch arms when a real backend exists.
class UrlConstants {
  const UrlConstants._();

  static String get authBaseUrl => switch (EnvConstants.flavor) {
    Flavor.dev => 'https://dummyjson.com',
    Flavor.preprod => 'https://dummyjson.com',
    Flavor.prod => 'https://dummyjson.com',
  };

  static const String loginPath = '/auth/login';
  static const String mePath = '/auth/me';
}
