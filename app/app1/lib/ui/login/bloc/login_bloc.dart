import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../base/bloc/base_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

@injectable
class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  LoginBloc(this._loginUseCase, this._getAppVersionUseCase, this._appNavigator)
    : super(const LoginState()) {
    on<LoginStarted>(_onStarted);
    on<LoginSubmitted>(_onSubmitted);
  }

  final LoginUseCase _loginUseCase;
  final GetAppVersionUseCase _getAppVersionUseCase;
  final AppNavigator _appNavigator;

  Future<void> _onStarted(LoginStarted event, Emitter<LoginState> emit) =>
      runBlocCatching(
        action: () async {
          final output = await _getAppVersionUseCase.execute(const NoInput());
          emit(state.copyWith(appVersion: output.version));
        },
        // The label is cosmetic - a failure just leaves it hidden.
      );

  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) =>
      runBlocCatching(
        action: () async {
          emit(state.copyWith(status: LoginStatus.loading, errorMessage: ''));

          await _loginUseCase.execute(
            LoginInput(username: event.username, password: event.password),
          );

          await _appNavigator.replaceAll(const AppRouteInfo.home());
        },
        doOnError: (exception) async {
          emit(
            state.copyWith(
              status: LoginStatus.failure,
              errorMessage: exception.message,
            ),
          );
        },
      );
}
