import 'package:app1/app/bloc/app_bloc.dart';
import 'package:app1/app/bloc/app_event.dart';
import 'package:app1/app/bloc/app_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class MockGetLanguageUseCase extends Mock implements GetLanguageUseCase {}

class MockSetLanguageUseCase extends Mock implements SetLanguageUseCase {}

void main() {
  late MockGetLanguageUseCase getLanguageUseCase;
  late MockSetLanguageUseCase setLanguageUseCase;

  setUpAll(() {
    registerFallbackValue(const NoInput());
    registerFallbackValue(const SetLanguageInput(languageCode: 'en'));
  });

  setUp(() {
    getLanguageUseCase = MockGetLanguageUseCase();
    setLanguageUseCase = MockSetLanguageUseCase();
  });

  AppBloc buildBloc() => AppBloc(getLanguageUseCase, setLanguageUseCase);

  group('AppBloc', () {
    blocTest<AppBloc, AppState>(
      'loads the persisted language on start',
      build: () {
        when(
          () => getLanguageUseCase.execute(any()),
        ).thenReturn(const GetLanguageOutput(languageCode: 'hi'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AppEvent.started()),
      expect: () => [const AppState(languageCode: 'hi')],
    );

    blocTest<AppBloc, AppState>(
      'persists and emits the new language on change',
      build: () {
        when(() => setLanguageUseCase.execute(any())).thenAnswer((_) async {});
        return buildBloc();
      },
      act: (bloc) =>
          bloc.add(const AppEvent.languageChanged(languageCode: 'hi')),
      expect: () => [const AppState(languageCode: 'hi')],
      verify: (_) {
        verify(
          () => setLanguageUseCase.execute(
            const SetLanguageInput(languageCode: 'hi'),
          ),
        ).called(1);
      },
    );

    blocTest<AppBloc, AppState>(
      'keeps the current language when persisting fails',
      build: () {
        when(
          () => setLanguageUseCase.execute(any()),
        ).thenThrow(const ValidationException('Unsupported language'));
        return buildBloc();
      },
      act: (bloc) =>
          bloc.add(const AppEvent.languageChanged(languageCode: 'fr')),
      expect: () => const <AppState>[],
    );

    test('AppState exposes the language as a Locale', () {
      expect(const AppState(languageCode: 'hi').locale.languageCode, 'hi');
    });
  });
}
