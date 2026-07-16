import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

/// Thin Dio wrapper that returns decoded JSON maps and normalizes transport
/// failures into [RemoteException]. Per-service clients extend this with
/// their own base URL and interceptor stack.
class RestApiClient {
  RestApiClient({
    required String baseUrl,
    List<Interceptor> interceptors = const [],
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 15),
           receiveTimeout: const Duration(seconds: 15),
           contentType: Headers.jsonContentType,
         ),
       ) {
    _dio.interceptors.addAll(interceptors);
  }

  final Dio _dio;

  Future<Map<String, dynamic>> get(String path) =>
      _request(() => _dio.get<dynamic>(path));

  Future<Map<String, dynamic>> post(String path, {Object? body}) =>
      _request(() => _dio.post<dynamic>(path, data: body));

  Future<Map<String, dynamic>> _request(
    Future<Response<dynamic>> Function() send,
  ) async {
    try {
      final response = await send();
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data;
      }
      throw RemoteException(
        statusCode: response.statusCode,
        message: 'Unexpected response shape: ${data.runtimeType}',
      );
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  /// Maps a [DioException] to a [RemoteException], surfacing the backend's
  /// `message` field when the error body contains one.
  static RemoteException mapDioException(DioException exception) {
    final response = exception.response;
    final data = response?.data;
    final backendMessage = data is Map<String, dynamic>
        ? data['message'] as String?
        : null;

    return RemoteException(
      statusCode: response?.statusCode,
      message:
          backendMessage ??
          exception.message ??
          'Network request failed (${exception.type.name})',
    );
  }
}
