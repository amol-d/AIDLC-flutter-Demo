import 'package:flutter/services.dart' show appFlavor;

import '../model/flavor.dart';

/// Values injected at build time.
class EnvConstants {
  const EnvConstants._();

  static const String flavorKey = 'FLAVOR';

  static const String _definedFlavorName = String.fromEnvironment(flavorKey);

  /// Resolution order:
  /// 1. `--dart-define FLAVOR=<name>` (works everywhere, incl. web)
  /// 2. the native `--flavor <name>` (Android productFlavor / iOS scheme,
  ///    surfaced by Flutter as [appFlavor])
  /// 3. dev
  static Flavor get flavor {
    if (_definedFlavorName.isNotEmpty) {
      return Flavor.fromName(_definedFlavorName);
    }
    return Flavor.fromName(appFlavor ?? Flavor.dev.name);
  }
}
