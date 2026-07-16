import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app/my_app.dart';
import 'config/app_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Path-based URLs on web (/login, /home) instead of /#/ fragments.
  usePathUrlStrategy();

  await AppInitializer.init();

  runApp(const MyApp());
}
