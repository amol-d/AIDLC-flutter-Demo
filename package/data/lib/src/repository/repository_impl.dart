import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

import 'model/auth/login_request.dart';
import 'source/api/app_api_service.dart';
import 'source/api/mapper/auth_token_data_mapper.dart';
import 'source/api/mapper/login_user_data_mapper.dart';
import 'source/api/mapper/user_data_mapper.dart';
import 'source/preference/app_preferences.dart';

@LazySingleton(as: Repository)
class RepositoryImpl implements Repository {
  const RepositoryImpl(
    this._apiService,
    this._appPreferences,
    this._authTokenDataMapper,
    this._loginUserDataMapper,
    this._userDataMapper,
  );

  final AppApiService _apiService;
  final AppPreferences _appPreferences;
  final AuthTokenDataMapper _authTokenDataMapper;
  final LoginUserDataMapper _loginUserDataMapper;
  final UserDataMapper _userDataMapper;

  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiService.login(
      LoginRequest(username: username, password: password),
    );

    final authToken = _authTokenDataMapper.mapToEntity(response);
    if (!authToken.isValid) {
      // A 200 without a token is a business error, not a transport error.
      throw const RemoteException(message: 'Login response missing token');
    }

    await _appPreferences.saveTokens(
      accessToken: authToken.accessToken,
      refreshToken: authToken.refreshToken,
    );

    return _loginUserDataMapper.mapToEntity(response);
  }

  @override
  Future<User> getCurrentUser() async =>
      _userDataMapper.mapToEntity(await _apiService.getMe());

  @override
  bool get isLoggedIn => _appPreferences.isLoggedIn;

  @override
  Future<void> logout() => _appPreferences.clearTokens();

  @override
  String get languageCode => _appPreferences.languageCode;

  @override
  Future<void> saveLanguageCode(String languageCode) =>
      _appPreferences.saveLanguageCode(languageCode);
}
