import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

/// Wire shape of GET /auth/me (subset of fields the app uses).
@JsonSerializable(createToJson: false)
class UserResponse {
  const UserResponse({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.image,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? image;
}
