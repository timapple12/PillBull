import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../database/database.dart';
import '../models/medication.dart';

class NotificationService {

  NotificationService(this._database)
      : _notifications = FlutterLocalNotificationsPlugin();
  final FlutterLocalNotificationsPlugin _notifications;
  final AppDatabase _database;

  Future<void> initialize() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@android:drawable/sym_def_app_icon');
    
    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings();
    
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // Request notification permissions for Android 13+
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    print("Notification initialized");
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    // You can navigate to specific screen or show dialog
    print('Notification tapped: ${response.payload}');
  }

  /// Schedule notifications for a medication based on its schedule
  Future<void> scheduleIntakeNotifications({
    required Medication medication,
    required Schedule schedule,
  }) async {
    if (!schedule.isActive) {
      return;
    }
    
    // Cancel existing notifications for this medication
    await cancelNotificationsForMedication(medication.id);
    
    final now = DateTime.now();
    final endDate = schedule.endDate;
    
    // Calculate frequency increment in days
    final int frequencyInDays = _calculateFrequencyInDays(
      schedule.frequencyValue,
      schedule.frequencyUnit,
    );
    
    // Calculate all notification times within the schedule
    for (final pattern in schedule.patterns) {
      DateTime currentDate = schedule.startDate;
      
      // Iterate through each day in the schedule based on frequency
      while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
        // Skip past dates
        if (currentDate.isBefore(DateTime(now.year, now.month, now.day))) {
          currentDate = currentDate.add(Duration(days: frequencyInDays));
          continue;
        }
        
        // Schedule notifications for each time slot
        for (final timeSlot in pattern.dailySlots) {
          final scheduledTime = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            timeSlot.hour,
            timeSlot.minute,
          );
          
          // Only schedule future notifications
          if (scheduledTime.isAfter(now)) {
            // Create intake record if it doesn't exist
            await _createIntakeRecordIfNeeded(
              medication.id,
              scheduledTime,
            );
            
            // Schedule reminder notification (15 minutes before)
            await _scheduleReminderNotification(
              medication: medication,
              scheduledTime: scheduledTime,
              pillsCount: pattern.pillsPerSlot,
            );
            
            // Schedule main notification
            await _scheduleMainNotification(
              medication: medication,
              scheduledTime: scheduledTime,
              pillsCount: pattern.pillsPerSlot,
            );
            
            // Schedule follow-up notification (30 minutes after)
            await _scheduleFollowUpNotification(
              medication: medication,
              scheduledTime: scheduledTime,
            );
          }
        }
        
        // Increment by frequency (e.g., every 2 days, every week, etc.)
        currentDate = currentDate.add(Duration(days: frequencyInDays));
        
        // Limit to 30 days in advance to avoid too many scheduled notifications
        if (currentDate.isAfter(now.add(const Duration(days: 30)))) {
          break;
        }
      }
    }
  }

  /// Calculate frequency in days based on value and unit
  int _calculateFrequencyInDays(int value, String unit) {
    switch (unit) {
      case 'days':
        return value;
      case 'weeks':
        return value * 7;
      case 'months':
        return value * 30; // Approximate month as 30 days
      default:
        return 1; // Default to daily
    }
  }

  /// Create intake record if it doesn't exist for scheduled time
  Future<void> _createIntakeRecordIfNeeded(
    String medicationId,
    DateTime scheduledTime,
  ) async {
    // Check if record already exists
    final query = _database.select(_database.intakeRecords)
      ..where((tbl) => tbl.medicationId.equals(medicationId))
      ..where((tbl) => tbl.scheduledTime.equals(scheduledTime));
    final existingRecords = await query.get();
    
    if (existingRecords.isEmpty) {
      // Create new scheduled record
      await _database.into(_database.intakeRecords).insert(
        IntakeRecordsCompanion.insert(
          id: '${medicationId}_${scheduledTime.millisecondsSinceEpoch}',
          medicationId: medicationId,
          scheduledTime: scheduledTime,
          status: IntakeStatusDto.scheduled,
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  /// Schedule reminder notification 15 minutes before
  Future<void> _scheduleReminderNotification({
    required Medication medication,
    required DateTime scheduledTime,
    required int pillsCount,
  }) async {
    final reminderTime = scheduledTime.subtract(const Duration(minutes: 15));
    
    if (reminderTime.isBefore(DateTime.now())) return;
    
    // Check quiet hours
    if (_isQuietHours(reminderTime)) return;
    
    final notificationId = _getNotificationId(medication.id, scheduledTime, 'reminder');
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Medication Reminders',
      channelDescription: 'Reminders for medication intake',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@android:drawable/sym_def_app_icon',
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.zonedSchedule(
      notificationId,
      '⏰ Скоро час ліків',
      '${medication.name} через 15 хвилин ($pillsCount табл.)',
      tz.TZDateTime.from(reminderTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'reminder_${medication.id}_${scheduledTime.millisecondsSinceEpoch}',
    );
  }

  /// Schedule main notification at scheduled time
  Future<void> _scheduleMainNotification({
    required Medication medication,
    required DateTime scheduledTime,
    required int pillsCount,
  }) async {
    if (scheduledTime.isBefore(DateTime.now())) return;
    
    // Check quiet hours
    if (_isQuietHours(scheduledTime)) return;
    
    final notificationId = _getNotificationId(medication.id, scheduledTime, 'main');
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Medication Reminders',
      channelDescription: 'Reminders for medication intake',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@android:drawable/sym_def_app_icon',
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.zonedSchedule(
      notificationId,
      '💊 Час прийняти ліки!',
      '${medication.name} - $pillsCount таблеток',
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'main_${medication.id}_${scheduledTime.millisecondsSinceEpoch}',
    );
  }

  /// Schedule follow-up notification 30 minutes after
  Future<void> _scheduleFollowUpNotification({
    required Medication medication,
    required DateTime scheduledTime,
  }) async {
    final followUpTime = scheduledTime.add(const Duration(minutes: 30));
    
    if (followUpTime.isBefore(DateTime.now())) return;
    
    // Check quiet hours
    if (_isQuietHours(followUpTime)) return;
    
    final notificationId = _getNotificationId(medication.id, scheduledTime, 'followup');
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Medication Reminders',
      channelDescription: 'Reminders for medication intake',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@android:drawable/sym_def_app_icon',
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.zonedSchedule(
      notificationId,
      '🔔 Нагадування',
      'Ви прийняли ${medication.name}?',
      tz.TZDateTime.from(followUpTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'followup_${medication.id}_${scheduledTime.millisecondsSinceEpoch}',
    );
  }

  /// Cancel all notifications for a specific medication
  Future<void> cancelNotificationsForMedication(String medicationId) async {
    // Get all pending notifications
    final pendingNotifications = await _notifications.pendingNotificationRequests();
    
    // Cancel notifications that belong to this medication
    for (final notification in pendingNotifications) {
      if (notification.payload?.contains(medicationId) ?? false) {
        await _notifications.cancel(notification.id);
      }
    }
  }

  /// Reschedule all notifications (call after app update or timezone change)
  Future<void> rescheduleAllNotifications() async {
    // Get all active schedules
    final activeSchedules = await (_database.select(_database.schedules)
          ..where((tbl) => tbl.isActive.equals(true)))
        .get();
    
    // Cancel all existing notifications
    await _notifications.cancelAll();
    
    // Reschedule for each medication
    for (final schedule in activeSchedules) {
      final medications = await (_database.select(_database.medications)
            ..where((tbl) => tbl.id.equals(schedule.medicationId)))
          .get();
      
      if (medications.isNotEmpty) {
        await scheduleIntakeNotifications(
          medication: medications.first,
          schedule: schedule,
        );
      }
    }
  }

  /// Generate unique notification ID
  int _getNotificationId(String medicationId, DateTime scheduledTime, String type) {
    // Combine medication ID, time, and type to create unique ID
    final combined = '$medicationId${scheduledTime.millisecondsSinceEpoch}$type';
    return combined.hashCode.abs() % 2147483647; // Keep within int32 range
  }

  /// Check if time is within quiet hours (22:00 - 07:00)
  bool _isQuietHours(DateTime time) {
    final hour = time.hour;
    return hour >= 22 || hour < 7;
  }

  /// Show immediate notification (for testing)
  Future<void> showImmediateNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Medication Reminders',
      channelDescription: 'Reminders for medication intake',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@android:drawable/sym_def_app_icon',
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      title,
      body,
      details,
      payload: payload,
    );
  }
}
