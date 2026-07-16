import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../repository/repository.dart';
import '../base/base_sync_use_case.dart';
import '../base/no_input.dart';

part 'check_login_status_use_case.freezed.dart';

@Injectable()
class CheckLoginStatusUseCase
    extends BaseSyncUseCase<NoInput, CheckLoginStatusOutput> {
  const CheckLoginStatusUseCase(this._repository);

  final Repository _repository;

  @override
  CheckLoginStatusOutput buildUseCase(NoInput input) =>
      CheckLoginStatusOutput(isLoggedIn: _repository.isLoggedIn);
}

@freezed
class CheckLoginStatusOutput with _$CheckLoginStatusOutput {
  const factory CheckLoginStatusOutput({required bool isLoggedIn}) =
      _CheckLoginStatusOutput;
}
