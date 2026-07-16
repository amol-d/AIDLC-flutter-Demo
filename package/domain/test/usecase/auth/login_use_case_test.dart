import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late MockRepository repository;
  late LoginUseCase useCase;

  const user = User(id: 1, username: 'emilys', firstName: 'Emily');

  setUp(() {
    repository = MockRepository();
    useCase = LoginUseCase(repository);
  });

  group('LoginUseCase', () {
    test(
      'forwards trimmed username and raw password to the repository',
      () async {
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => user);

        final output = await useCase.execute(
          const LoginInput(username: '  emilys  ', password: 'emilyspass'),
        );

        expect(output.user, user);
        verify(
          () => repository.login(username: 'emilys', password: 'emilyspass'),
        ).called(1);
      },
    );

    test(
      'throws ValidationException for blank username without calling repo',
      () async {
        expect(
          () =>
              useCase.execute(const LoginInput(username: '   ', password: 'x')),
          throwsA(isA<ValidationException>()),
        );
        verifyZeroInteractions(repository);
      },
    );

    test('throws ValidationException for empty password', () async {
      expect(
        () =>
            useCase.execute(const LoginInput(username: 'emilys', password: '')),
        throwsA(isA<ValidationException>()),
      );
    });
  });
}
