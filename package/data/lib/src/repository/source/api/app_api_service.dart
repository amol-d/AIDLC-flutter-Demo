import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

import '../../model/auth/login_request.dart';
import '../../model/auth/login_response.dart';
import '../../model/auth/user_response.dart';
import 'client/auth_app_server_api_client.dart';

/// Central API facade - one method per endpoint. RepositoryImpl talks to
/// this instead of raw clients so endpoints stay discoverable in one place.
@lazySingleton
class AppApiService {
  const AppApiService(this._authClient);

  final AuthAppServerApiClient _authClient;

  Future<LoginResponse> login(LoginRequest request) async =>
      LoginResponse.fromJson(
        await _authClient.post(UrlConstants.loginPath, body: request.toJson()),
      );

  Future<UserResponse> getMe() async =>
      UserResponse.fromJson(await _authClient.get(UrlConstants.mePath));
}
