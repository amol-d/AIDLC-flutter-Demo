import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../base/bloc/base_bloc.dart';
import 'app_event.dart';
import 'app_state.dart';

/// App-wide state (UI locale + app version). Registered as a lazy singleton
/// because MyApp and the Settings screen share the same instance.
@LazySingleton()
class AppBloc extends BaseBloc<AppEvent, AppState> {
  AppBloc(
    this._getLanguageUseCase,
    this._setLanguageUseCase,
    this._getAppVersionUseCase,
  ) : super(const AppState()) {
    on<AppStarted>(_onStarted);
    on<AppLanguageChanged>(_onLanguageChanged);
  }

  final GetLanguageUseCase _getLanguageUseCase;
  final SetLanguageUseCase _setLanguageUseCase;
  final GetAppVersionUseCase _getAppVersionUseCase;

  Future<void> _onStarted(AppStarted event, Emitter<AppState> emit) {
    final language = _getLanguageUseCase.execute(const NoInput());
    emit(state.copyWith(languageCode: language.languageCode));

    // The version label is cosmetic - a lookup failure just leaves it hidden.
    return runBlocCatching(
      action: () async {
        final version = await _getAppVersionUseCase.execute(const NoInput());
        emit(state.copyWith(appVersion: version.version));
      },
    );
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
