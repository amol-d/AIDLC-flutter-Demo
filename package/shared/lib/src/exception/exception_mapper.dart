import 'package:injectable/injectable.dart';

import 'app_exception.dart';
import 'unknown_exception.dart';

/// Normalizes any thrown object into an [AppException]. Transport-specific
/// mapping (e.g. DioException -> RemoteException) happens in the data layer;
/// this is the last-resort mapper used by [runCatching] and blocs.
@lazySingleton
class AppExceptionMapper {
  const AppExceptionMapper();

  AppException map(Object error) =>
      error is AppException ? error : UnknownException(error.toString());
}
