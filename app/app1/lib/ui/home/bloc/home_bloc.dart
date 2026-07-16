import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../base/bloc/base_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  HomeBloc(this._getCurrentUserUseCase, this._logoutUseCase, this._appNavigator)
    : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeLogoutPressed>(_onLogoutPressed);
    on<HomeSettingsPressed>(_onSettingsPressed);
  }

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;
  final AppNavigator _appNavigator;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) =>
      runBlocCatching(
        action: () async {
          emit(state.copyWith(status: HomeStatus.loading));

          final output = await _getCurrentUserUseCase.execute(const NoInput());

          emit(state.copyWith(status: HomeStatus.success, user: output.user));
        },
        doOnError: (exception) async {
          emit(
            state.copyWith(
              status: HomeStatus.failure,
              errorMessage: exception.message,
            ),
          );
        },
      );

  Future<void> _onLogoutPressed(
    HomeLogoutPressed event,
    Emitter<HomeState> emit,
  ) => runBlocCatching(
    action: () async {
      await _logoutUseCase.execute(const NoInput());
      await _appNavigator.replaceAll(const AppRouteInfo.login());
    },
  );

  Future<void> _onSettingsPressed(
    HomeSettingsPressed event,
    Emitter<HomeState> emit,
  ) => runBlocCatching(
    action: () => _appNavigator.push(const AppRouteInfo.settings()),
  );
}
