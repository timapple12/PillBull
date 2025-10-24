import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../calendar/presentation/screens/calendar_screen.dart';
import '../../../medications/presentation/screens/medications_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart' show SettingsScreen;
import '../../../statistics/presentation/screens/statistics_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CalendarScreen(),
    const MedicationsScreen(),
    const StatisticsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final navItems = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.calendar_today),
        label: l10n.calendar,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.medication),
        label: l10n.medications,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.analytics),
        label: l10n.statistics,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        label: l10n.settings,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: navItems,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 8,
      ),
    );
  }
}
