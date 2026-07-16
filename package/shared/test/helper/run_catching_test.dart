import 'package:flutter_test/flutter_test.dart';
import 'package:shared/src/exception/remote_exception.dart';
import 'package:shared/src/exception/unknown_exception.dart';
import 'package:shared/src/helper/result.dart';
import 'package:shared/src/helper/run_catching.dart';

void main() {
  group('runCatching', () {
    test('wraps a returned value in Success', () async {
      final result = await runCatching(() async => 'ok');

      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, 'ok');
    });

    test('preserves thrown AppExceptions', () async {
      final result = await runCatching<void>(
        () async => throw const RemoteException(statusCode: 401),
      );

      final exception = (result as Failure).exception;
      expect(exception, isA<RemoteException>());
      expect((exception as RemoteException).isUnauthorized, isTrue);
    });

    test('maps arbitrary errors to UnknownException', () async {
      final result = await runCatching<void>(() async => throw StateError('x'));

      expect((result as Failure).exception, isA<UnknownException>());
    });
  });
}
