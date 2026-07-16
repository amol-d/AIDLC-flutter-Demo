import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';

import '../../common_view/flavor_badge.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<HomeBloc>()..add(const HomeEvent.started()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.home),
        actions: [
          const Center(child: FlavorBadge()),
          IconButton(
            key: const Key('home_logout_button'),
            tooltip: s.logout,
            icon: const Icon(Icons.logout),
            onPressed: () =>
                context.read<HomeBloc>().add(const HomeEvent.logoutPressed()),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return switch (state.status) {
            HomeStatus.initial || HomeStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            HomeStatus.failure => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 8),
                  Text(state.errorMessage),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () =>
                        context.read<HomeBloc>().add(const HomeEvent.started()),
                    child: Text(s.retry),
                  ),
                ],
              ),
            ),
            HomeStatus.success => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 48,
                    foregroundImage: state.user.imageUrl.isNotEmpty
                        ? NetworkImage(state.user.imageUrl)
                        : null,
                    child: const Icon(Icons.person, size: 48),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.user.fullName,
                    key: const Key('home_user_name'),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${state.user.username}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.user.email,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '${s.environment}: ${EnvConstants.flavor.label}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          };
        },
      ),
    );
  }
}
