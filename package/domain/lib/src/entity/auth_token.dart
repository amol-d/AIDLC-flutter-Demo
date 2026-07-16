import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token.freezed.dart';

@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    @Default('') String accessToken,
    @Default('') String refreshToken,
  }) = _AuthToken;

  const AuthToken._();

  bool get isValid => accessToken.isNotEmpty;
}
