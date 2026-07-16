import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    @Default(0) int id,
    @Default('') String username,
    @Default('') String email,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String imageUrl,
  }) = _User;

  const User._();

  String get fullName =>
      [firstName, lastName].where((part) => part.isNotEmpty).join(' ');
}
