import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../repository/repository.dart';
import '../base/base_sync_use_case.dart';
import '../base/no_input.dart';

part 'get_language_use_case.freezed.dart';

@Injectable()
class GetLanguageUseCase extends BaseSyncUseCase<NoInput, GetLanguageOutput> {
  const GetLanguageUseCase(this._repository);

  final Repository _repository;

  @override
  GetLanguageOutput buildUseCase(NoInput input) =>
      GetLanguageOutput(languageCode: _repository.languageCode);
}

@freezed
class GetLanguageOutput with _$GetLanguageOutput {
  const factory GetLanguageOutput({@Default('en') String languageCode}) =
      _GetLanguageOutput;
}
