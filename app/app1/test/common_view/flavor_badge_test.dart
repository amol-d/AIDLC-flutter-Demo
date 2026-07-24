import 'package:app1/common_view/flavor_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';

void main() {
  const violet = Color(0xFF8F00FF);

  for (final (flavor, color) in [
    (Flavor.dev, Colors.green),
    (Flavor.preprod, Colors.blue),
    (Flavor.prod, violet),
  ]) {
    testWidgets('uses the ${flavor.label} color scheme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FlavorBadge(flavor: flavor)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;
      final text = tester.widget<Text>(find.text(flavor.label));

      expect(decoration.color, color.withValues(alpha: 0.15));
      expect(decoration.border, Border.all(color: color));
      expect(text.style?.color, color);
    });
  }
}
