import 'package:meta/meta.dart';

/// Base class for synchronous use cases (no awaits anywhere in the chain).
abstract class BaseSyncUseCase<Input, Output> {
  const BaseSyncUseCase();

  Output execute(Input input) => buildUseCase(input);

  @protected
  Output buildUseCase(Input input);
}
