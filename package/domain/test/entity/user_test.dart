import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    test('fullName joins non-empty parts', () {
      const user = User(firstName: 'Emily', lastName: 'Johnson');
      expect(user.fullName, 'Emily Johnson');
    });

    test('fullName skips empty parts', () {
      const user = User(firstName: 'Emily');
      expect(user.fullName, 'Emily');
      expect(const User().fullName, '');
    });
  });

  group('AuthToken', () {
    test('isValid requires a non-empty access token', () {
      expect(const AuthToken(accessToken: 'abc').isValid, isTrue);
      expect(const AuthToken().isValid, isFalse);
    });
  });
}
