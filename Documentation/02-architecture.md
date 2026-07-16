# Architecture

## Layers and dependency direction

```
            +-------------------+
            |  app/app1, app2   |   UI, blocs, router, DI wiring
            +---------+---------+
                      | depends on
        +-------------+-------------+
        v                           v
+---------------+          +---------------+
|    domain     | <------- |     data      |
| entities,     |          | DTOs, mappers,|
| use cases,    |          | API clients,  |
| Repository    |          | RepositoryImpl|
| contract      |          +-------+-------+
+-------+-------+                  |
        |                          |
        +-----------+--------------+
                    v
            +---------------+
            |    shared     |  constants, exceptions, Result, l10n, Flavor
            +---------------+
```

Rules (enforced in review):
- `domain` must NEVER import `data` or any transport type (dio, shared_preferences).
- Apps never import each other.
- Blocs call **use cases**, never `Repository` directly.
- Navigation from blocs goes through the `AppNavigator` abstraction (defined in domain),
  never `context.router`.

## API-backed feature flow

```
Bloc/UI -> use case -> Repository contract -> RepositoryImpl -> AppApiService/client
        -> response DTO -> mapper -> domain entity -> back up the chain
```

| Piece | Path |
|---|---|
| Entities | `package/domain/lib/src/entity/` |
| Use cases | `package/domain/lib/src/usecase/` |
| Repository contract | `package/domain/lib/src/repository/repository.dart` |
| Response DTOs | `package/data/lib/src/repository/model/` |
| API service | `package/data/lib/src/repository/source/api/app_api_service.dart` |
| Mappers | `package/data/lib/src/repository/source/api/mapper/` |
| Repository impl | `package/data/lib/src/repository/repository_impl.dart` |
| Endpoints | `package/shared/lib/src/constants/url_constants.dart` |

## Error model

- `AppException` (shared) is the base for intentional errors: `RemoteException`
  (transport + HTTP status), `ValidationException` (use-case input), `UnknownException`.
- The data layer maps `DioException` -> `RemoteException`
  (`RestApiClient.mapDioException`), surfacing the backend `message` field.
- Business errors inside 200 responses are raised explicitly (see the missing-token check
  in `RepositoryImpl.login`).
- Blocs run work inside `runBlocCatching` (`app/*/lib/base/bloc/base_bloc.dart`), which
  normalizes anything thrown into an `AppException` for the error state.
- `Result<T>` + `runCatching` (shared) exist for non-bloc call sites.

## Use case contract

`BaseFutureUseCase<Input, Output>` (async) and `BaseSyncUseCase` (sync) in
`package/domain/lib/src/usecase/base/`. Freezed `Input`/`Output` types per use case;
input validation happens at the top of `buildUseCase` before any I/O.
