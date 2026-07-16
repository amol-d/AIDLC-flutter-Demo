import '../model/flavor.dart';

/// Values injected at build time via `--dart-define`.
class EnvConstants {
  const EnvConstants._();

  static const String flavorKey = 'FLAVOR';

  static const String _flavorName = String.fromEnvironment(
    flavorKey,
    defaultValue: 'dev',
  );

  static Flavor get flavor => Flavor.fromName(_flavorName);
}
