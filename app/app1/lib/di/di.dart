import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

/// Registers all injectables declared in app1 (blocs, router, navigator).
/// Must run last - it depends on every lower layer being registered.
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
GetIt configureAppInjection(GetIt getIt) => getIt.init();
