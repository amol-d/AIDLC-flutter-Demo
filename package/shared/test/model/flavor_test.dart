import 'package:flutter_test/flutter_test.dart';
import 'package:shared/src/model/flavor.dart';

void main() {
  group('Flavor', () {
    test('parses known names case-insensitively', () {
      expect(Flavor.fromName('PREPROD'), Flavor.preprod);
      expect(Flavor.fromName('prod'), Flavor.prod);
    });

    test('falls back to dev for unknown names', () {
      expect(Flavor.fromName('staging'), Flavor.dev);
      expect(Flavor.fromName(''), Flavor.dev);
    });
  });
}
