import 'package:app1/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// End-to-end integration test: boots the real app and verifies the auth guard
/// routes a logged-out user to the login screen. Runs on a device/emulator or
/// (in CI) on Chrome via `flutter drive`; Firebase Test Lab is documented as a
/// follow-up for a real-device matrix.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('boots to the login screen when logged out', (tester) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Not authenticated -> AuthGuard redirects to /login, which shows the
    // username + password fields.
    expect(find.byType(TextField), findsWidgets);
  });
}
