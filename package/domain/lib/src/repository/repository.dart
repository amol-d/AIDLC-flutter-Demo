import '../entity/user.dart';

/// Single data-access contract for the app. Implemented in package/data by
/// RepositoryImpl; the domain layer must never depend on that implementation.
abstract class Repository {
  /// Authenticates against the backend, persists the auth token internally,
  /// and returns the signed-in user.
  Future<User> login({required String username, required String password});

  /// Fetches the profile of the currently authenticated user.
  Future<User> getCurrentUser();

  /// Whether a persisted auth token exists.
  bool get isLoggedIn;

  /// Clears any persisted authentication state.
  Future<void> logout();
}
