import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../repository/repository.dart';
import '../base/base_future_use_case.dart';
import '../base/no_input.dart';

part 'get_app_version_use_case.freezed.dart';

@Injectable()
class GetAppVersionUseCase
    extends BaseFutureUseCase<NoInput, GetAppVersionOutput> {
  const GetAppVersionUseCase(this._repository);

  final Repository _repository;

  @override
  Future<GetAppVersionOutput> buildUseCase(NoInput input) async =>
      GetAppVersionOutput(version: await _repository.getAppVersion());
}

@freezed
class GetAppVersionOutput with _$GetAppVersionOutput {
  const factory GetAppVersionOutput({@Default('') String version}) =
      _GetAppVersionOutput;
}
