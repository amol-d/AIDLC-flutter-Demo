# State Management

## Pattern

**flutter_bloc** with Freezed events/states. One bloc per feature screen, living in
`app/app1/lib/ui/<feature>/bloc/` as a triplet:

- `<feature>_bloc.dart` — extends `BaseBloc`, `@injectable`
- `<feature>_event.dart` — `@freezed` union of events
- `<feature>_state.dart` — `@freezed` state + a status enum

## BaseBloc and runBlocCatching

`app/app1/lib/base/bloc/base_bloc.dart`:

```dart
Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) =>
    runBlocCatching(
      action: () async {
        emit(state.copyWith(status: LoginStatus.loading));
        await _loginUseCase.execute(LoginInput(...));
        await _appNavigator.replaceAll(const AppRouteInfo.home());
      },
      doOnError: (exception) async {
        emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: exception.message,
        ));
      },
    );
```

`runBlocCatching` normalizes anything thrown into an `AppException`, so event handlers
never crash and error states always carry a user-presentable message.

## Rules

- Blocs receive **use cases** (and `AppNavigator`) via constructor injection — never
  `Repository`, `AppApiService`, or Dio.
- Pages create blocs from GetIt: `BlocProvider(create: (_) => GetIt.I<LoginBloc>())`.
  In widget tests, register a mock bloc factory in `setUp` and `getIt.reset()` in
  `tearDown`.
- No business logic in widgets; widgets render state and dispatch events.
- Prefer `copyWith` on a single state class + status enum over multi-class state
  hierarchies for simple screens.
