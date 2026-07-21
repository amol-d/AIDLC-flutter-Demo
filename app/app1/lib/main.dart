import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app/my_app.dart';
import 'config/app_initializer.dart';
import 'config/crash_reporter.dart';

Future<void> main() async {
  // runZonedGuarded funnels uncaught async errors to crash reporting.
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Path-based URLs on web (/login, /home) instead of /#/ fragments.
    usePathUrlStrategy();

    // Defensive: no-op on web / without Firebase config (see crash_reporter).
    await initCrashReporting();

    await AppInitializer.init();

    runApp(const MyApp());
  }, recordZoneError);
}
