import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Exposes install-time application metadata (version, build number).
@lazySingleton
class AppInfoDataSource {
  const AppInfoDataSource();

  /// Returns the app version in pubspec form, e.g. `1.0.0+1`.
  Future<String> getVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.buildNumber.isEmpty
        ? info.version
        : '${info.version}+${info.buildNumber}';
  }
}
