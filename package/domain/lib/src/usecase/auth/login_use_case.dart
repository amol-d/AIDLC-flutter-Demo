import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

import '../../entity/user.dart';
import '../../repository/repository.dart';
import '../base/base_future_use_case.dart';

part 'login_use_case.freezed.dart';

@Injectable()
class LoginUseCase extends BaseFutureUseCase<LoginInput, LoginOutput> {
  const LoginUseCase(this._repository);

  final Repository _repository;

  @override
  Future<LoginOutput> buildUseCase(LoginInput input) async {
    if (input.username.trim().isEmpty || input.password.isEmpty) {
      throw const ValidationException('Username and password are required');
    }

    final user = await _repository.login(
      username: input.username.trim(),
      password: input.password,
    );

    return LoginOutput(user: user);
  }
}

@freezed
class LoginInput with _$LoginInput {
  const factory LoginInput({
    required String username,
    required String password,
  }) = _LoginInput;
}

@freezed
class LoginOutput with _$LoginOutput {
  const factory LoginOutput({required User user}) = _LoginOutput;
}
