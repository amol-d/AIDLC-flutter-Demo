import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

/// Wire shape of POST /auth/login. Field names follow the transport; all
/// fields stay nullable and are defaulted during mapping. dummyjson returns
/// `accessToken` today but older deployments used `token`, so both are kept.
@JsonSerializable(createToJson: false)
class LoginResponse {
  const LoginResponse({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.image,
    this.accessToken,
    this.refreshToken,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? image;
  final String? accessToken;
  final String? refreshToken;
  final String? token;

  /// The usable access token regardless of which key the backend sent.
  String? get effectiveAccessToken => accessToken ?? token;
}
