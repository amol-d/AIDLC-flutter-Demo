/// Category of an [AppException]; lets UI layers branch without type checks.
enum AppExceptionKind { remote, validation, unknown }

/// Base type for every error the app raises intentionally.
abstract class AppException implements Exception {
  const AppException(this.kind, this.message);

  final AppExceptionKind kind;
  final String message;

  @override
  String toString() => '$runtimeType(${kind.name}): $message';
}
