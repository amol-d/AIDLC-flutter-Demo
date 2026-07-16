import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

/// Base class for every bloc in the app. Blocs call domain use cases (never
/// Repository directly) and wrap that work in [runBlocCatching] so thrown
/// errors surface as [AppException]s instead of crashing the event handler.
abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  BaseBloc(super.initialState);

  Future<void> runBlocCatching({
    required Future<void> Function() action,
    Future<void> Function(AppException exception)? doOnError,
    Future<void> Function()? doOnCompleted,
  }) async {
    try {
      await action();
    } catch (error) {
      await doOnError?.call(const AppExceptionMapper().map(error));
    } finally {
      await doOnCompleted?.call();
    }
  }
}
