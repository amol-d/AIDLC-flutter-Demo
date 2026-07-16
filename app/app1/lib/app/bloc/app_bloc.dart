import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../base/bloc/base_bloc.dart';
import 'app_event.dart';
import 'app_state.dart';

/// App-wide state (currently the UI locale). Registered as a lazy singleton
/// because MyApp and the Settings screen share the same instance.
@LazySingleton()
class AppBloc extends BaseBloc<AppEvent, AppState> {
  AppBloc(this._getLanguageUseCase, this._setLanguageUseCase)
    : super(const AppState()) {
    on<AppStarted>(_onStarted);
    on<AppLanguageChanged>(_onLanguageChanged);
  }

  final GetLanguageUseCase _getLanguageUseCase;
  final SetLanguageUseCase _setLanguageUseCase;

  void _onStarted(AppStarted event, Emitter<AppState> emit) {
    final output = _getLanguageUseCase.execute(const NoInput());
    emit(state.copyWith(languageCode: output.languageCode));
  }

  Future<void> _onLanguageChanged(
    AppLanguageChanged event,
    Emitter<AppState> emit,
  ) => runBlocCatching(
    action: () async {
      await _setLanguageUseCase.execute(
        SetLanguageInput(languageCode: event.languageCode),
      );
      emit(state.copyWith(languageCode: event.languageCode));
    },
  );
}
