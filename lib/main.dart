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
    
    // Initialize notification scheduler service
    final notificationSchedulerService = container.read(notificationSchedulerServiceProvider);
    await notificationSchedulerService.initialize();
    debugPrint('✅ NotificationSchedulerService initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('❌ Failed to initialize services: $e');
    debugPrint('StackTrace: $stackTrace');
  }
  
  runApp(UncontrolledProviderScope(
    container: container,
    child: const PillBullApp(),
  ));
}

class PillBullApp extends ConsumerStatefulWidget {
  const PillBullApp({super.key});

  @override
  ConsumerState<PillBullApp> createState() => _PillBullAppState();
}

class _PillBullAppState extends ConsumerState<PillBullApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final schedulerService = ref.read(notificationSchedulerServiceProvider);
    
    switch (state) {
      case AppLifecycleState.resumed:
        schedulerService.onAppResumed();
      case AppLifecycleState.paused:
        schedulerService.onAppPaused();
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
