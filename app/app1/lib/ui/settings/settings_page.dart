import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';

import '../../app/bloc/app_bloc.dart';
import '../../app/bloc/app_event.dart';
import '../../app/bloc/app_state.dart';
import '../../common_view/flavor_badge.dart';
import 'bloc/settings_bloc.dart';
import 'bloc/settings_event.dart';
import 'bloc/settings_state.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // AppBloc is the app-level singleton that owns the locale; the whole
    // MaterialApp rebuilds when it emits, so the toggle applies instantly.
    // SettingsBloc owns this screen's own actions (logout).
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: GetIt.I<AppBloc>()),
        BlocProvider(create: (_) => GetIt.I<SettingsBloc>()),
      ],
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.settings),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(child: FlavorBadge()),
          ),
        ],
      ),
      body: BlocListener<SettingsBloc, SettingsState>(
        listenWhen: (previous, current) =>
            current.status == SettingsStatus.failure &&
            previous.status != SettingsStatus.failure,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
        },
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            return ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(
                    s.language,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                RadioGroup<String>(
                  groupValue: state.languageCode,
                  onChanged: (code) {
                    if (code != null) {
                      context.read<AppBloc>().add(
                        AppEvent.languageChanged(languageCode: code),
                      );
                    }
                  },
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        key: const Key('settings_language_en'),
                        value: SetLanguageUseCase.supportedLanguageCodes[0],
                        title: Text(s.english),
                      ),
                      RadioListTile<String>(
                        key: const Key('settings_language_hi'),
                        value: SetLanguageUseCase.supportedLanguageCodes[1],
                        title: Text(s.hindi),
                      ),
                    ],
                  ),
                ),
                if (state.appVersion.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      s.versionLabel(state.appVersion),
                      key: const Key('settings_version_label'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const Divider(),
                BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, settingsState) {
                    final loggingOut =
                        settingsState.status == SettingsStatus.loading;
                    final color = Theme.of(context).colorScheme.error;
                    return ListTile(
                      key: const Key('settings_logout_button'),
                      leading: Icon(Icons.logout, color: color),
                      title: Text(s.logout, style: TextStyle(color: color)),
                      trailing: loggingOut
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : null,
                      onTap: loggingOut
                          ? null
                          : () => context.read<SettingsBloc>().add(
                              const SettingsEvent.logoutPressed(),
                            ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
