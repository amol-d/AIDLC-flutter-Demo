import '../exception/app_exception.dart';

/// Lightweight success/failure wrapper used by [runCatching].
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(AppException exception) failure,
  }) => switch (this) {
    Success<T>(:final data) => success(data),
    Failure<T>(:final exception) => failure(exception),
  };
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.exception);
  final AppException exception;
}
