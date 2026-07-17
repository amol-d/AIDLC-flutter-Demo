import 'package:app1/app/bloc/app_bloc.dart';
import 'package:app1/app/bloc/app_event.dart';
import 'package:app1/ui/settings/settings_page.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class MockGetLanguageUseCase extends Mock implements GetLanguageUseCase {}

class MockSetLanguageUseCase extends Mock implements SetLanguageUseCase {}

class MockGetAppVersionUseCase extends Mock implements GetAppVersionUseCase {}

void main() {
  final getIt = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(const NoInput());
  });

  setUp(() {
    final getLanguageUseCase = MockGetLanguageUseCase();
    when(
      () => getLanguageUseCase.execute(any()),
    ).thenReturn(const GetLanguageOutput(languageCode: 'en'));

    final getAppVersionUseCase = MockGetAppVersionUseCase();
    when(
      () => getAppVersionUseCase.execute(any()),
    ).thenAnswer((_) async => const GetAppVersionOutput(version: '9.9.9+99'));

    // The page reads the app-level AppBloc singleton from GetIt.
    getIt.registerLazySingleton<AppBloc>(
      () => AppBloc(
        getLanguageUseCase,
        MockSetLanguageUseCase(),
        getAppVersionUseCase,
      )..add(const AppEvent.started()),
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
    home: SettingsPage(),
  );

  testWidgets('shows a bold version label under the language options', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final labelFinder = find.byKey(const Key('settings_version_label'));
    expect(labelFinder, findsOneWidget);
    expect(find.text('Version 9.9.9+99'), findsOneWidget);

    final label = tester.widget<Text>(labelFinder);
    expect(label.style?.fontWeight, FontWeight.bold);
  });

  testWidgets('renders the language options', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('settings_language_en')), findsOneWidget);
    expect(find.byKey(const Key('settings_language_hi')), findsOneWidget);
  });
}
