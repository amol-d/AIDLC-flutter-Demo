import 'package:app1/ui/login/bloc/login_bloc.dart';
import 'package:app1/ui/login/bloc/login_event.dart';
import 'package:app1/ui/login/bloc/login_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockGetAppVersionUseCase extends Mock implements GetAppVersionUseCase {}

class MockAppNavigator extends Mock implements AppNavigator {}

void main() {
  late MockLoginUseCase loginUseCase;
  late MockGetAppVersionUseCase getAppVersionUseCase;
  late MockAppNavigator appNavigator;

  const user = User(id: 1, username: 'emilys');

  setUpAll(() {
    registerFallbackValue(const LoginInput(username: '', password: ''));
    registerFallbackValue(const AppRouteInfo.home());
    registerFallbackValue(const NoInput());
  });

  setUp(() {
    loginUseCase = MockLoginUseCase();
    getAppVersionUseCase = MockGetAppVersionUseCase();
    appNavigator = MockAppNavigator();
  });

  LoginBloc buildBloc() =>
      LoginBloc(loginUseCase, getAppVersionUseCase, appNavigator);

  group('LoginBloc', () {
    blocTest<LoginBloc, LoginState>(
      'loads the app version on start',
      build: () {
        when(() => getAppVersionUseCase.execute(any())).thenAnswer(
          (_) async => const GetAppVersionOutput(version: '1.2.3+4'),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoginEvent.started()),
      expect: () => [const LoginState(appVersion: '1.2.3+4')],
    );

    blocTest<LoginBloc, LoginState>(
      'stays silent when the version lookup fails',
      build: () {
        when(
          () => getAppVersionUseCase.execute(any()),
        ).thenThrow(const UnknownException('no platform info'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoginEvent.started()),
      expect: () => const <LoginState>[],
    );

    blocTest<LoginBloc, LoginState>(
      'emits loading then navigates home on success',
      build: () {
        when(
          () => loginUseCase.execute(any()),
        ).thenAnswer((_) async => const LoginOutput(user: user));
        when(() => appNavigator.replaceAll(any())).thenAnswer((_) async {});
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        const LoginEvent.submitted(username: 'emilys', password: 'pass'),
      ),
      expect: () => [const LoginState(status: LoginStatus.loading)],
      verify: (_) {
        verify(
          () => loginUseCase.execute(
            const LoginInput(username: 'emilys', password: 'pass'),
          ),
        ).called(1);
        verify(
          () => appNavigator.replaceAll(const AppRouteInfo.home()),
        ).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits failure with the exception message on error',
      build: () {
        when(() => loginUseCase.execute(any())).thenThrow(
          const RemoteException(
            statusCode: 400,
            message: 'Invalid credentials',
          ),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        const LoginEvent.submitted(username: 'emilys', password: 'wrong'),
      ),
      expect: () => [
        const LoginState(status: LoginStatus.loading),
        const LoginState(
          status: LoginStatus.failure,
          errorMessage: 'Invalid credentials',
        ),
      ],
      verify: (_) {
        verifyNever(() => appNavigator.replaceAll(any()));
      },
    );
  });
}
