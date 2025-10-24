import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'router/app_router.dart';
import 'theme/industrial_dark_theme.dart';
import 'core/localization/app_localizations.dart';
import 'core/controllers/language_controller.dart';

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
    final currentLocale = ref.watch(languageControllerProvider);

    return MaterialApp.router(
      title: 'AproFleet Manager',
      debugShowCheckedModeBanner: false,

      // Theme - Industrial Dark UI System
      theme: IndustrialDarkTheme.darkTheme,

      // Localization
      locale: currentLocale,
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
