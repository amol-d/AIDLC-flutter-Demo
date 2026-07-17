import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    @Default('en') String languageCode,
    @Default('') String appVersion,
  }) = _AppState;

  const AppState._();

  Locale get locale => Locale(languageCode);
}
