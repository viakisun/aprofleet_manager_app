import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'core/localization/app_localizations.dart';
import 'core/services/providers.dart';

void main() {
  runApp(
    ProviderScope(
      child: AproFleetApp(),
    ),
  );
}

class AproFleetApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initializeAsync = ref.watch(initializeAppProvider);

    return initializeAsync.when(
      data: (_) => MaterialApp.router(
        title: 'AproFleet Manager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: ref.watch(routerProvider),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ja', ''),
          Locale('ko', ''),
        ],
      ),
      loading: () => MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFF0A0A0A),
          body: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
      error: (err, stack) => MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFF0A0A0A),
          body: Center(
            child: Text(
              'Error initializing app: $err',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
