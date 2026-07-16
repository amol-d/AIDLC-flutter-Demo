import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

/// Registers all injectables declared in package/shared.
/// Must run before the data/domain/app layers initialize.
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
GetIt configureSharedInjection(GetIt getIt) => getIt.init();
