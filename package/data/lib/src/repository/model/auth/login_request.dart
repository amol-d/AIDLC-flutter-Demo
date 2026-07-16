import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable(createFactory: false)
class LoginRequest {
  const LoginRequest({
    required this.username,
    required this.password,
    this.expiresInMins = 30,
  });

  final String username;
  final String password;
  final int expiresInMins;

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
