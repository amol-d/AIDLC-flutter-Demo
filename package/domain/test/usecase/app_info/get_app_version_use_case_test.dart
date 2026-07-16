import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  group('GetAppVersionUseCase', () {
    test('returns the version from the repository', () async {
      final repository = MockRepository();
      when(() => repository.getAppVersion()).thenAnswer((_) async => '1.2.3+4');

      final output = await GetAppVersionUseCase(
        repository,
      ).execute(const NoInput());

      expect(output.version, '1.2.3+4');
      verify(() => repository.getAppVersion()).called(1);
    });
  });
}
