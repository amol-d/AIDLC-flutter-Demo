import 'package:app1/ui/settings/bloc/settings_bloc.dart';
import 'package:app1/ui/settings/bloc/settings_event.dart';
import 'package:app1/ui/settings/bloc/settings_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockAppNavigator extends Mock implements AppNavigator {}

void main() {
  late MockLogoutUseCase logoutUseCase;
  late MockAppNavigator appNavigator;

  setUpAll(() {
    registerFallbackValue(const NoInput());
    registerFallbackValue(const AppRouteInfo.login());
  });

  setUp(() {
    logoutUseCase = MockLogoutUseCase();
    appNavigator = MockAppNavigator();
  });

  SettingsBloc buildBloc() => SettingsBloc(logoutUseCase, appNavigator);

  group('SettingsBloc', () {
    blocTest<SettingsBloc, SettingsState>(
      'logout clears the session and navigates to login',
      build: () {
        when(() => logoutUseCase.execute(any())).thenAnswer((_) async {});
        when(() => appNavigator.replaceAll(any())).thenAnswer((_) async {});
        return buildBloc();
      },
      act: (bloc) => bloc.add(const SettingsEvent.logoutPressed()),
      expect: () => const [SettingsState(status: SettingsStatus.loading)],
      verify: (_) {
        verify(() => logoutUseCase.execute(const NoInput())).called(1);
        verify(
          () => appNavigator.replaceAll(const AppRouteInfo.login()),
        ).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'emits failure and does not navigate when logout throws',
      build: () {
        when(
          () => logoutUseCase.execute(any()),
        ).thenThrow(const UnknownException('logout failed'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const SettingsEvent.logoutPressed()),
      expect: () => const [
        SettingsState(status: SettingsStatus.loading),
        SettingsState(
          status: SettingsStatus.failure,
          errorMessage: 'logout failed',
        ),
      ],
      verify: (_) {
        verifyNever(() => appNavigator.replaceAll(any()));
      },
    );
  });
}
