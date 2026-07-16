import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late MockRepository repository;

  setUp(() {
    repository = MockRepository();
  });

  group('GetLanguageUseCase', () {
    test('returns the persisted language code', () {
      when(() => repository.languageCode).thenReturn('hi');

      final output = GetLanguageUseCase(repository).execute(const NoInput());

      expect(output.languageCode, 'hi');
    });
  });

  group('SetLanguageUseCase', () {
    test('forwards supported codes to the repository', () async {
      when(() => repository.saveLanguageCode(any())).thenAnswer((_) async {});

      await SetLanguageUseCase(
        repository,
      ).execute(const SetLanguageInput(languageCode: 'hi'));

      verify(() => repository.saveLanguageCode('hi')).called(1);
    });

    test(
      'throws ValidationException for unsupported codes without saving',
      () async {
        expect(
          () => SetLanguageUseCase(
            repository,
          ).execute(const SetLanguageInput(languageCode: 'fr')),
          throwsA(isA<ValidationException>()),
        );
        verifyZeroInteractions(repository);
      },
    );
  });
}
