import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_event.freezed.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.started() = LoginStarted;
  const factory LoginEvent.submitted({
    required String username,
    required String password,
  }) = LoginSubmitted;
}
