import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

import '../../preference/app_preferences.dart';
import '../middleware/auth_interceptor.dart';
import '../middleware/custom_log_interceptor.dart';
import '../middleware/header_interceptor.dart';
import '../rest_api_client.dart';

/// Client for the main auth-backed API (dummyjson in this demo).
@lazySingleton
class AuthAppServerApiClient extends RestApiClient {
  AuthAppServerApiClient(AppPreferences appPreferences)
    : super(
        baseUrl: UrlConstants.authBaseUrl,
        interceptors: [
          const HeaderInterceptor(),
          AuthInterceptor(appPreferences),
          const CustomLogInterceptor(),
        ],
      );
}
