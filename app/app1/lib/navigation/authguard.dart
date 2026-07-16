import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import 'routes/app_router.gr.dart';

/// Blocks guarded routes when no auth token is persisted, redirecting to
/// login. Runs on direct navigation, web slugs, and deeplinks alike.
@Injectable()
class AuthGuard extends AutoRouteGuard {
  AuthGuard(this._checkLoginStatusUseCase);

  final CheckLoginStatusUseCase _checkLoginStatusUseCase;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isLoggedIn = _checkLoginStatusUseCase
        .execute(const NoInput())
        .isLoggedIn;

    if (isLoggedIn) {
      resolver.next();
    } else {
      // Park the attempted route; after a successful login the stack is
      // replaced with /home anyway.
      unawaited(resolver.redirect(const LoginRoute()));
    }
  }
}
