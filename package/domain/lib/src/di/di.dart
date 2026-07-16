import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

/// Registers all injectables declared in package/domain.
/// Requires the shared and data layers to be initialized first (the
/// Repository implementation must already be registered).
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
GetIt configureDomainInjection(GetIt getIt) => getIt.init();
