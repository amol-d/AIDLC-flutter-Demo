import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../base/bloc/base_bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';

@injectable
class SettingsBloc extends BaseBloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._logoutUseCase, this._appNavigator)
    : super(const SettingsState()) {
    on<SettingsLogoutPressed>(_onLogoutPressed);
  }

  final LogoutUseCase _logoutUseCase;
  final AppNavigator _appNavigator;

  Future<void> _onLogoutPressed(
    SettingsLogoutPressed event,
    Emitter<SettingsState> emit,
  ) => runBlocCatching(
    action: () async {
      emit(state.copyWith(status: SettingsStatus.loading));
      await _logoutUseCase.execute(const NoInput());
      await _appNavigator.replaceAll(const AppRouteInfo.login());
    },
    doOnError: (exception) async {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          errorMessage: exception.message,
        ),
      );
    },
  );
}
