import 'package:app1/ui/login/bloc/login_bloc.dart';
import 'package:app1/ui/login/login_page.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockGetAppVersionUseCase extends Mock implements GetAppVersionUseCase {}

class MockAppNavigator extends Mock implements AppNavigator {}

void main() {
  final getIt = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(const NoInput());
  });

  setUp(() {
    final getAppVersionUseCase = MockGetAppVersionUseCase();
    when(
      () => getAppVersionUseCase.execute(any()),
    ).thenAnswer((_) async => const GetAppVersionOutput(version: '9.9.9+99'));

    // Pages resolve their bloc from GetIt, so tests must register it first.
    getIt.registerFactory<LoginBloc>(
      () => LoginBloc(
        MockLoginUseCase(),
        getAppVersionUseCase,
        MockAppNavigator(),
      ),
    );
  });

  tearDown(() => getIt.reset());

  Widget buildSubject() => const MaterialApp(
    localizationsDelegates: [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [Locale('en')],
    home: LoginPage(),
  );

  testWidgets('renders username, password, and submit controls', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login_username_field')), findsOneWidget);
    expect(find.byKey(const Key('login_password_field')), findsOneWidget);
    expect(find.byKey(const Key('login_submit_button')), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('shows the app version under the submit button', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login_version_label')), findsOneWidget);
    expect(find.text('Version 9.9.9+99'), findsOneWidget);
  });

  testWidgets('shows validation errors when submitting empty form', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('This field is required'), findsNWidgets(2));
  });
}
