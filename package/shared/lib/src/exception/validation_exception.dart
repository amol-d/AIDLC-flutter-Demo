import 'app_exception.dart';

/// Raised by use cases when input fails validation before any I/O happens.
class ValidationException extends AppException {
  const ValidationException(String message)
    : super(AppExceptionKind.validation, message);
}
