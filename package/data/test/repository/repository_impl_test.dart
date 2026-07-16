import 'package:data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class MockAppApiService extends Mock implements AppApiService {}

class MockAppPreferences extends Mock implements AppPreferences {}

void main() {
  late MockAppApiService apiService;
  late MockAppPreferences appPreferences;
  late RepositoryImpl repository;

  setUp(() {
    apiService = MockAppApiService();
    appPreferences = MockAppPreferences();
    repository = RepositoryImpl(
      apiService,
      appPreferences,
      const AuthTokenDataMapper(),
      const LoginUserDataMapper(),
      const UserDataMapper(),
    );
  });

  setUpAll(() {
    registerFallbackValue(const LoginRequest(username: '', password: ''));
  });

  group('login', () {
    test('persists tokens and returns the mapped user', () async {
      when(() => apiService.login(any())).thenAnswer(
        (_) async => const LoginResponse(
          id: 1,
          username: 'emilys',
          firstName: 'Emily',
          accessToken: 'access-1',
          refreshToken: 'refresh-1',
        ),
      );
      when(
        () => appPreferences.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      final user = await repository.login(username: 'emilys', password: 'pass');

      expect(user.username, 'emilys');
      verify(
        () => appPreferences.saveTokens(
          accessToken: 'access-1',
          refreshToken: 'refresh-1',
        ),
      ).called(1);
    });

    test(
      'throws RemoteException when a 200 arrives without any token',
      () async {
        when(
          () => apiService.login(any()),
        ).thenAnswer((_) async => const LoginResponse(id: 1));

        expect(
          () => repository.login(username: 'u', password: 'p'),
          throwsA(isA<RemoteException>()),
        );
        verifyNever(
          () => appPreferences.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        );
      },
    );
  });

  group('getCurrentUser', () {
    test('maps the /auth/me response', () async {
      when(
        () => apiService.getMe(),
      ).thenAnswer((_) async => const UserResponse(id: 9, username: 'emilys'));

      final user = await repository.getCurrentUser();

      expect(user.id, 9);
    });
  });

  group('session state', () {
    test('isLoggedIn delegates to preferences', () {
      when(() => appPreferences.isLoggedIn).thenReturn(true);

      expect(repository.isLoggedIn, isTrue);
    });

    test('logout clears persisted tokens', () async {
      when(() => appPreferences.clearTokens()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => appPreferences.clearTokens()).called(1);
    });
  });

  group('language', () {
    test('languageCode delegates to preferences', () {
      when(() => appPreferences.languageCode).thenReturn('hi');

      expect(repository.languageCode, 'hi');
    });

    test('saveLanguageCode persists via preferences', () async {
      when(
        () => appPreferences.saveLanguageCode(any()),
      ).thenAnswer((_) async {});

      await repository.saveLanguageCode('hi');

      verify(() => appPreferences.saveLanguageCode('hi')).called(1);
    });
  });
}
