# Networking & Data

## Client stack

```
AppApiService (facade, one method per endpoint)
  └─ AuthAppServerApiClient (per-API-family client, @lazySingleton)
       └─ RestApiClient (Dio wrapper: JSON maps out, RemoteException on failure)
            └─ interceptors: HeaderInterceptor -> AuthInterceptor -> CustomLogInterceptor
```

- `RestApiClient` (`package/data/lib/src/repository/source/api/rest_api_client.dart`)
  returns decoded `Map<String, dynamic>` and converts `DioException` ->
  `RemoteException`, surfacing the backend `message` field when present.
- `AuthInterceptor` attaches `Authorization: Bearer <token>` from `AppPreferences`.
- `HeaderInterceptor` adds `x-app-flavor`. `CustomLogInterceptor` logs method/URL/status
  only (never bodies or headers), and only outside prod.
- New API family (different base URL) = new client class next to
  `AuthAppServerApiClient`, base URL from `UrlConstants`.

## DTOs

`package/data/lib/src/repository/model/<feature>/` — json_serializable, **all wire fields
nullable**, transport names preserved. Tolerant parsing is explicit and tested: e.g.
`LoginResponse.effectiveAccessToken` reads `accessToken` with a legacy `token` fallback.

## Mappers

`BaseDataMapper<Response, Model>`
(`package/data/lib/src/repository/source/api/mapper/base/base_data_mapper.dart`) maps a
nullable DTO to a non-null entity with safe defaults; `mapToEntityList` handles lists.
One mapper class per Response->Entity pair, `@Injectable()`.

## Repository

`RepositoryImpl` (`@LazySingleton(as: Repository)`) orchestrates API + persistence:
`login` calls the API, validates that a token actually arrived (business error on a 200
without one), persists it, and returns the mapped `User`. `isLoggedIn` is synchronous off
`AppPreferences`.

## Persistence

`AppPreferences` wraps `SharedPreferences` (localStorage on web). Keys live in
`StringConstants`. Store only what must survive restarts (tokens); no ad-hoc keys.
