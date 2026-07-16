import 'app_exception.dart';

/// API/network failure, carrying the HTTP status when one was received.
class RemoteException extends AppException {
  const RemoteException({this.statusCode, String message = 'Network error'})
    : super(AppExceptionKind.remote, message);

  final int? statusCode;

  bool get isUnauthorized => statusCode == 401 || statusCode == 403;
  bool get isNoConnection => statusCode == null;
}
