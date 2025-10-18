import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'core/localization/app_localizations.dart';
import 'core/controllers/language_controller.dart';
import 'core/services/providers.dart';

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
    // 앱 초기화 상태 감시
    final initAsync = ref.watch(initializeAppProvider);
    final currentLocale = ref.watch(languageControllerProvider);

    return initAsync.when(
      // 초기화 완료
      data: (_) {
        final router = ref.watch(appRouterProvider);
        
        return MaterialApp.router(
          title: 'AproFleet Manager',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          locale: currentLocale,
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
            Locale('zh', 'CN'),
            Locale('zh', 'TW'),
          ],
          routerConfig: router,
        );
      },
      // 초기화 중
      loading: () => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          backgroundColor: const Color(0xFF0A0A0A),
          body: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
      // 초기화 실패
      error: (err, stack) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          backgroundColor: const Color(0xFF0A0A0A),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Failed to initialize app',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  err.toString(),
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
