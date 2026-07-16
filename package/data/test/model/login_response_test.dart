import 'package:data/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginResponse.fromJson', () {
    test('parses the current dummyjson wire shape (accessToken)', () {
      final response = LoginResponse.fromJson(const {
        'id': 1,
        'username': 'emilys',
        'email': 'emily.johnson@x.dummyjson.com',
        'firstName': 'Emily',
        'lastName': 'Johnson',
        'gender': 'female',
        'image': 'https://dummyjson.com/icon/emilys/128',
        'accessToken': 'access-123',
        'refreshToken': 'refresh-456',
      });

      expect(response.id, 1);
      expect(response.username, 'emilys');
      expect(response.effectiveAccessToken, 'access-123');
      expect(response.refreshToken, 'refresh-456');
    });

    test('falls back to the legacy token key', () {
      final response = LoginResponse.fromJson(const {
        'id': 1,
        'username': 'emilys',
        'token': 'legacy-789',
      });

      expect(response.effectiveAccessToken, 'legacy-789');
    });

    test('tolerates missing fields entirely', () {
      final response = LoginResponse.fromJson(const {});

      expect(response.effectiveAccessToken, isNull);
      expect(response.username, isNull);
    });
  });
}
