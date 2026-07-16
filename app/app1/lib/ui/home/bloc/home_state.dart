import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

enum HomeStatus { initial, loading, success, failure }

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStatus.initial) HomeStatus status,
    @Default(User()) User user,
    @Default('') String errorMessage,
  }) = _HomeState;
}
