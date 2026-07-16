import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

import '../../repository/repository.dart';
import '../base/base_future_use_case.dart';

part 'set_language_use_case.freezed.dart';

@Injectable()
class SetLanguageUseCase extends BaseFutureUseCase<SetLanguageInput, void> {
  const SetLanguageUseCase(this._repository);

  static const supportedLanguageCodes = ['en', 'hi'];

  final Repository _repository;

  @override
  Future<void> buildUseCase(SetLanguageInput input) {
    if (!supportedLanguageCodes.contains(input.languageCode)) {
      throw ValidationException(
        'Unsupported language code: ${input.languageCode}',
      );
    }

    return _repository.saveLanguageCode(input.languageCode);
  }
}

@freezed
class SetLanguageInput with _$SetLanguageInput {
  const factory SetLanguageInput({required String languageCode}) =
      _SetLanguageInput;
}
