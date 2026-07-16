import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

enum LoginStatus { initial, loading, failure }

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(LoginStatus.initial) LoginStatus status,
    @Default('') String errorMessage,
  }) = _LoginState;
}
