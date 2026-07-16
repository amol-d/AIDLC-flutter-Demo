import 'package:data/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthTokenDataMapper', () {
    const mapper = AuthTokenDataMapper();

    test('maps accessToken and refreshToken', () {
      final token = mapper.mapToEntity(
        const LoginResponse(accessToken: 'a', refreshToken: 'r'),
      );

      expect(token.accessToken, 'a');
      expect(token.refreshToken, 'r');
      expect(token.isValid, isTrue);
    });

    test('uses legacy token key when accessToken is absent', () {
      final token = mapper.mapToEntity(const LoginResponse(token: 'legacy'));

      expect(token.accessToken, 'legacy');
    });

    test('maps null response to empty (invalid) token', () {
      final token = mapper.mapToEntity(null);

      expect(token.isValid, isFalse);
      expect(token.refreshToken, '');
    });
  });

  group('UserDataMapper', () {
    const mapper = UserDataMapper();

    test('maps all fields with non-null defaults', () {
      final user = mapper.mapToEntity(
        const UserResponse(
          id: 5,
          username: 'emilys',
          email: 'e@x.com',
          firstName: 'Emily',
          lastName: 'Johnson',
          image: 'https://img',
        ),
      );

      expect(user.id, 5);
      expect(user.fullName, 'Emily Johnson');
      expect(user.imageUrl, 'https://img');
    });

    test('maps null response to defaults', () {
      final user = mapper.mapToEntity(null);

      expect(user.id, 0);
      expect(user.username, '');
    });

    test('mapToEntityList handles null and values', () {
      expect(mapper.mapToEntityList(null), isEmpty);
      expect(mapper.mapToEntityList(const [UserResponse(id: 1)]).single.id, 1);
    });
  });
}
