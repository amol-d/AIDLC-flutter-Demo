import '../exception/exception_mapper.dart';
import 'result.dart';

/// Runs [action] and wraps the outcome in a [Result], normalizing anything
/// thrown into an AppException via [AppExceptionMapper].
Future<Result<T>> runCatching<T>(Future<T> Function() action) async {
  try {
    return Success(await action());
  } catch (error) {
    return Failure(const AppExceptionMapper().map(error));
  }
}
