import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'features/main/presentation/screens/main_screen.dart';
import 'generated/l10n/app_localizations.dart';
import 'shared/providers/locale_provider.dart';
import 'shared/providers/notification_provider.dart';
import 'shared/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final container = ProviderContainer();
  
  // Pre-load SharedPreferences for theme
  final themeNotifier = container.read(themeProvider.notifier);
  await themeNotifier.loadThemeMode();
  
  // Initialize notification service immediately at app start
  try {
    final notificationService = container.read(notificationServiceProvider);
    await notificationService.initialize();
    debugPrint('✅ Notifications initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('❌ Failed to initialize notifications: $e');
    debugPrint('StackTrace: $stackTrace');
  }
  
  runApp(UncontrolledProviderScope(
    container: container,
    child: const PillBullApp(),
  ));
}

class PillBullApp extends ConsumerWidget {
  const PillBullApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('uk', ''), // Ukrainian
        Locale('de', ''), // German
      ],
      home: const MainScreen(),
    );
  }
}
