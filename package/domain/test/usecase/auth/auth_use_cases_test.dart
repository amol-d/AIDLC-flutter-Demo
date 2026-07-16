import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late MockRepository repository;

  setUp(() {
    repository = MockRepository();
  });

  group('GetCurrentUserUseCase', () {
    test('returns the user from the repository', () async {
      const user = User(id: 7, username: 'emilys', email: 'e@x.com');
      when(() => repository.getCurrentUser()).thenAnswer((_) async => user);

      final output = await GetCurrentUserUseCase(
        repository,
      ).execute(const NoInput());

      expect(output.user, user);
      verify(() => repository.getCurrentUser()).called(1);
    });
  });

  group('CheckLoginStatusUseCase', () {
    test('reflects repository.isLoggedIn', () {
      when(() => repository.isLoggedIn).thenReturn(true);

      final output = CheckLoginStatusUseCase(
        repository,
      ).execute(const NoInput());

      expect(output.isLoggedIn, isTrue);
    });
  });

  group('LogoutUseCase', () {
    test('delegates to repository.logout', () async {
      when(() => repository.logout()).thenAnswer((_) async {});

      await LogoutUseCase(repository).execute(const NoInput());

      verify(() => repository.logout()).called(1);
    });
  });
}
