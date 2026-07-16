import 'package:flutter_test/flutter_test.dart';
import 'package:shared/src/exception/unknown_exception.dart';
import 'package:shared/src/helper/result.dart';

void main() {
  group('Result', () {
    test('Success exposes data through when()', () {
      const Result<int> result = Success(42);

      expect(result.isSuccess, isTrue);
      expect(result.when(success: (data) => data, failure: (_) => -1), 42);
    });

    test('Failure exposes exception through when()', () {
      const Result<int> result = Failure(UnknownException('boom'));

      expect(result.isSuccess, isFalse);
      expect(
        result.when(success: (_) => '', failure: (e) => e.message),
        'boom',
      );
    });
  });
}
