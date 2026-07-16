import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';

import '../helper/deep_link_helper.dart';
import '../navigation/routes/app_router.dart';
import 'bloc/app_bloc.dart';
import 'bloc/app_event.dart';
import 'bloc/app_state.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = GetIt.I<AppRouter>();
  final DeepLinkHelper _deepLinkHelper = GetIt.I<DeepLinkHelper>();
  final AppBloc _appBloc = GetIt.I<AppBloc>()..add(const AppEvent.started());

  @override
  void initState() {
    super.initState();
    // Web handles URLs through the router's path strategy; app_links covers
    // mobile custom-scheme links (aidlc://app1/...).
    if (!kIsWeb) {
      _deepLinkHelper.listen();
    }
  }

  @override
  void dispose() {
    _deepLinkHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _appBloc,
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return MaterialApp.router(
            onGenerateTitle: (context) => S.of(context).appName,
            debugShowCheckedModeBanner: false,
            locale: state.locale,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF0D47A1),
              ),
              useMaterial3: true,
            ),
            routerConfig: _appRouter.config(),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
          );
        },
      ),
    );
  }
}
