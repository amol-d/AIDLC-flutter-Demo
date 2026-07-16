import 'package:app2/app/my_app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';

void main() {
  testWidgets('App2 renders the localized app name and environment', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('AIDLC Demo'), findsOneWidget);
    expect(find.textContaining(EnvConstants.flavor.label), findsOneWidget);
  });
}
