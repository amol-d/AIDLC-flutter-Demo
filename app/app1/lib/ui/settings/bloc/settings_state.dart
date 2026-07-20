import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

enum SettingsStatus { initial, loading, failure }

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(SettingsStatus.initial) SettingsStatus status,
    @Default('') String errorMessage,
  }) = _SettingsState;
}
