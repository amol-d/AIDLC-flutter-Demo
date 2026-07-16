import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';

import '../di/di.dart';

/// Boots dependency injection in strict layer order. Lower layers must
/// register before the layers that depend on them: shared -> data -> domain
/// -> app.
class AppInitializer {
  const AppInitializer._();

  static Future<void> init() async {
    final getIt = GetIt.instance;

    configureSharedInjection(getIt);
    await configureDataInjection(getIt);
    configureDomainInjection(getIt);
    configureAppInjection(getIt);
  }
}
