import 'package:app1/ui/home/bloc/home_bloc.dart';
import 'package:app1/ui/home/bloc/home_event.dart';
import 'package:app1/ui/home/bloc/home_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockAppNavigator extends Mock implements AppNavigator {}

void main() {
  late MockGetCurrentUserUseCase getCurrentUserUseCase;
  late MockLogoutUseCase logoutUseCase;
  late MockAppNavigator appNavigator;

  const user = User(id: 1, username: 'emilys', firstName: 'Emily');

  setUpAll(() {
    registerFallbackValue(const NoInput());
    registerFallbackValue(const AppRouteInfo.login());
  });

  setUp(() {
    getCurrentUserUseCase = MockGetCurrentUserUseCase();
    logoutUseCase = MockLogoutUseCase();
    appNavigator = MockAppNavigator();
  });

  HomeBloc buildBloc() =>
      HomeBloc(getCurrentUserUseCase, logoutUseCase, appNavigator);

  group('HomeBloc', () {
    blocTest<HomeBloc, HomeState>(
      'loads the current user on start',
      build: () {
        when(
          () => getCurrentUserUseCase.execute(any()),
        ).thenAnswer((_) async => const GetCurrentUserOutput(user: user));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const HomeEvent.started()),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        const HomeState(status: HomeStatus.success, user: user),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits failure when the profile fetch throws',
      build: () {
        when(() => getCurrentUserUseCase.execute(any())).thenThrow(
          const RemoteException(statusCode: 401, message: 'Unauthorized'),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const HomeEvent.started()),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        const HomeState(
          status: HomeStatus.failure,
          errorMessage: 'Unauthorized',
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'logout clears the session and navigates to login',
      build: () {
        when(() => logoutUseCase.execute(any())).thenAnswer((_) async {});
        when(() => appNavigator.replaceAll(any())).thenAnswer((_) async {});
        return buildBloc();
      },
      act: (bloc) => bloc.add(const HomeEvent.logoutPressed()),
      expect: () => const <HomeState>[],
      verify: (_) {
        verify(() => logoutUseCase.execute(const NoInput())).called(1);
        verify(
          () => appNavigator.replaceAll(const AppRouteInfo.login()),
        ).called(1);
      },
    );
  });
}
