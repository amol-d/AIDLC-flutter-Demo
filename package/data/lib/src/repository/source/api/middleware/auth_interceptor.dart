import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

import '../../preference/app_preferences.dart';

/// Attaches the persisted bearer token to outgoing requests.
class AuthInterceptor extends Interceptor {
  const AuthInterceptor(this._appPreferences);

  final AppPreferences _appPreferences;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _appPreferences.accessToken;
    if (token.isNotEmpty) {
      options.headers[StringConstants.authorizationHeader] =
          '${StringConstants.bearerPrefix}$token';
    }
    handler.next(options);
  }
}
