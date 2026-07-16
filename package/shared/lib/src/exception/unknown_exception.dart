import 'app_exception.dart';

/// Fallback for errors that no other [AppException] subtype describes.
class UnknownException extends AppException {
  const UnknownException([String message = 'Something went wrong'])
    : super(AppExceptionKind.unknown, message);
}
