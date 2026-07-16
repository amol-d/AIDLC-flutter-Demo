import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared/shared.dart';

/// Logs request/response summaries outside of prod. Never logs bodies or
/// headers, so tokens and credentials stay out of the console.
class CustomLogInterceptor extends Interceptor {
  const CustomLogInterceptor();

  bool get _enabled => EnvConstants.flavor != Flavor.prod;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_enabled) {
      debugPrint('--> ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_enabled) {
      debugPrint('<-- ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_enabled) {
      debugPrint(
        '<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}',
      );
    }
    handler.next(err);
  }
}
