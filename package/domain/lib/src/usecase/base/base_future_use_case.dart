import 'package:meta/meta.dart';

/// Base class for asynchronous single-result use cases.
///
/// Callers invoke [execute]; subclasses implement [buildUseCase]. Input
/// validation belongs at the top of [buildUseCase] (throw a
/// ValidationException before any I/O).
abstract class BaseFutureUseCase<Input, Output> {
  const BaseFutureUseCase();

  Future<Output> execute(Input input) => buildUseCase(input);

  @protected
  Future<Output> buildUseCase(Input input);
}
