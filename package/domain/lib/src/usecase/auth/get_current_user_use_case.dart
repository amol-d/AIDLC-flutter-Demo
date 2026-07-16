import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../entity/user.dart';
import '../../repository/repository.dart';
import '../base/base_future_use_case.dart';
import '../base/no_input.dart';

part 'get_current_user_use_case.freezed.dart';

@Injectable()
class GetCurrentUserUseCase
    extends BaseFutureUseCase<NoInput, GetCurrentUserOutput> {
  const GetCurrentUserUseCase(this._repository);

  final Repository _repository;

  @override
  Future<GetCurrentUserOutput> buildUseCase(NoInput input) async {
    final user = await _repository.getCurrentUser();

    return GetCurrentUserOutput(user: user);
  }
}

@freezed
class GetCurrentUserOutput with _$GetCurrentUserOutput {
  const factory GetCurrentUserOutput({required User user}) =
      _GetCurrentUserOutput;
}
