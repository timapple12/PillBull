import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../generated/l10n/app_localizations.dart';

class AppConstants {
  static const String appName = 'PillBull';
  static const String appVersion = '1.0.0';
  
  // Colors - Warm Pastel Palette with Purple Accent
  static const Color primaryColor = Color(0xFF9C88D4); // Soft purple
  static const Color secondaryColor = Color(0xFFE8DFF5); // Light lavender
  static const Color accentColor = Color(0xFFDEB8BC); // Dusty rose
  static const Color errorColor = Color(0xFFD98C96); // Soft red
  static const Color successColor = Color(0xFFA8D5BA); // Sage green
  static const Color warningColor = Color(0xFFFFCB9A); // Peach
  static const Color backgroundColor = Color(0xFFFAF8F3); // Warm cream
  
  // Calendar colors
  static const Color scheduledColor = Color(0xFFE8DFF5); // Light lavender
  static const Color takenColor = Color(0xFFD5E8D4); // Light sage
  static const Color missedColor = Color(0xFFFFE4E9); // Light pink
  static const Color skippedColor = Color(0xFFFFF4E6); // Light peach
  
  // Spacing
  static const double paddingSmall = 8;
  static const double paddingMedium = 16;
  static const double paddingLarge = 24;
  static const double paddingXLarge = 32;
  
  // Border radius
  static const double radiusSmall = 4;
  static const double radiusMedium = 8;
  static const double radiusLarge = 12;
  static const double radiusXLarge = 16;
  
  // Animation durations
  static const Duration animationShort = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationLong = Duration(milliseconds: 500);
  
  // Calendar settings
  static const int daysToShow = 7;
  static const int maxDaysInMonth = 31;
  
  // Notification settings
  static const int reminderMinutesBefore = 15;
  static const int followUpMinutesAfter = 30;
  static const int criticalReminderMinutesAfter = 60;
  
  // Quiet hours
  static const int quietHoursStart = 22; // 10 PM
  static const int quietHoursEnd = 7; // 7 AM
}

class AppTextStyles {
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
}

class AppIcons {
  static const String pill = '💊';
  static const String calendar = '📅';
  static const String clock = '🕐';
  static const String check = '✅';
  static const String cross = '❌';
  static const String warning = '⚠️';
  static const String settings = '⚙️';
  static const String statistics = '📊';
  static const String add = '➕';
  static const String edit = '✏️';
  static const String delete = '🗑️';
  static const String notification = '🔔';
  static const String history = '📋';
  static const String home = '🏠';
  
  // Medication icons - using Font Awesome
  static const List<IconData> medicationIcons = [
    FontAwesomeIcons.pills,
    FontAwesomeIcons.syringe,
    FontAwesomeIcons.bandage,
    FontAwesomeIcons.bottleDroplet,
    FontAwesomeIcons.droplet,
    FontAwesomeIcons.thermometer,
    FontAwesomeIcons.stethoscope,
    FontAwesomeIcons.flask,
    FontAwesomeIcons.vial,
    FontAwesomeIcons.clipboard,
    FontAwesomeIcons.notesMedical,
    FontAwesomeIcons.chartLine,
    FontAwesomeIcons.bell,
    FontAwesomeIcons.heartPulse,
  ];
}

class AppUtils {
  static String formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    
    if (targetDate == today) {
      return l10n.today;
    } else if (targetDate == today.add(const Duration(days: 1))) {
      return l10n.tomorrow;
    } else if (targetDate == today.subtract(const Duration(days: 1))) {
      return l10n.yesterday;
    } else {
      return '${date.day}.${date.month.toString().padLeft(2, '0')}';
    }
  }
  
  static String formatTime(DateTime time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  
  static String formatDateTime(DateTime dateTime, AppLocalizations l10n) => '${formatDate(dateTime, l10n)} ${formatTime(dateTime)}';
  
  static String getWeekdayName(DateTime date, AppLocalizations l10n) {
    switch (date.weekday) {
      case 1:
        return l10n.monday;
      case 2:
        return l10n.tuesday;
      case 3:
        return l10n.wednesday;
      case 4:
        return l10n.thursday;
      case 5:
        return l10n.friday;
      case 6:
        return l10n.saturday;
      case 7:
        return l10n.sunday;
      default:
        return '';
    }
  }
  
  static String getMonthName(DateTime date, AppLocalizations l10n) {
    switch (date.month) {
      case 1:
        return l10n.january;
      case 2:
        return l10n.february;
      case 3:
        return l10n.march;
      case 4:
        return l10n.april;
      case 5:
        return l10n.may;
      case 6:
        return l10n.june;
      case 7:
        return l10n.july;
      case 8:
        return l10n.august;
      case 9:
        return l10n.september;
      case 10:
        return l10n.october;
      case 11:
        return l10n.november;
      case 12:
        return l10n.december;
      default:
        return '';
    }
  }
  
  static int getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil();
  }
  
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }
  
  static bool isQuietHours(DateTime time) {
    final hour = time.hour;
    return hour >= AppConstants.quietHoursStart || hour < AppConstants.quietHoursEnd;
  }
  
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return AppConstants.scheduledColor;
      case 'taken':
        return AppConstants.takenColor;
      case 'missed':
        return AppConstants.missedColor;
      case 'skipped':
        return AppConstants.skippedColor;
      default:
        return AppConstants.scheduledColor;
    }
  }
  
  static String getStatusText(String status, AppLocalizations l10n) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return l10n.scheduled;
      case 'taken':
        return l10n.taken;
      case 'missed':
        return l10n.missed;
      case 'skipped':
        return l10n.skipped;
      default:
        return l10n.scheduled;
    }
  }
}
