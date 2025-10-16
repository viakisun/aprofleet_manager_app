import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'core/localization/app_localizations.dart';

void main() {
  runApp(
    const ProviderScope(
      child: AproFleetApp(),
    ),
  );
}

class AproFleetApp extends ConsumerWidget {
  const AproFleetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'AproFleet Manager',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.darkTheme,

      // Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ja', ''), // Japanese
        Locale('ko', ''), // Korean
      ],

      // Routing
      routerConfig: router,
    );
  }
}
