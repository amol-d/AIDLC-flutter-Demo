import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Key-value persistence for auth state. Backed by SharedPreferences, which
/// uses localStorage on web - so login survives a page refresh.
@lazySingleton
class AppPreferences {
  const AppPreferences(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  String get accessToken =>
      _sharedPreferences.getString(StringConstants.accessTokenKey) ?? '';

  bool get isLoggedIn => accessToken.isNotEmpty;

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _sharedPreferences.setString(
      StringConstants.accessTokenKey,
      accessToken,
    );
    await _sharedPreferences.setString(
      StringConstants.refreshTokenKey,
      refreshToken,
    );
  }

  Future<void> clearTokens() async {
    await _sharedPreferences.remove(StringConstants.accessTokenKey);
    await _sharedPreferences.remove(StringConstants.refreshTokenKey);
  }
}
