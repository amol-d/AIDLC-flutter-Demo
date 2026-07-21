@Tags(['golden'])
library;

import 'package:app1/common_view/flavor_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FlavorBadge renders the DEV chip', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: FlavorBadge())),
      ),
    );
    await expectLater(
      find.byType(FlavorBadge),
      matchesGoldenFile('goldens/flavor_badge.png'),
    );
  });
}
