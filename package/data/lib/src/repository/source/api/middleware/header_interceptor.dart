import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

/// Adds environment-identifying headers to every request.
class HeaderInterceptor extends Interceptor {
  const HeaderInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['x-app-flavor'] = EnvConstants.flavor.name;
    handler.next(options);
  }
}
