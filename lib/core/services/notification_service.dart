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
    try {
      // Initialize timezones with local location
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Europe/Kiev')); // Ukraine timezone
      
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );
      
      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      
      final initialized = await _notifications.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
      
      if (initialized == true) {
        // Request notification permissions for Android 13+
        final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        
        if (androidPlugin != null) {
          final granted = await androidPlugin.requestNotificationsPermission();
          print('📱 Notification permission: ${granted == true ? "GRANTED" : "DENIED"}');
          
          // Request exact alarm permission for Android 12+
          final exactAlarmGranted = await androidPlugin.requestExactAlarmsPermission();
          print('⏰ Exact alarm permission: ${exactAlarmGranted == true ? "GRANTED" : "DENIED"}');
        }
        
        print('✅ Notifications initialized successfully');
      } else {
        print('⚠️ Notifications initialization returned false');
      }
    } catch (e, stackTrace) {
      print('❌ Failed to initialize notifications: $e');
      print('StackTrace: $stackTrace');
      rethrow;
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    // You can navigate to specific screen or show dialog
    print('Notification tapped: ${response.payload}');
  }

  Future<void> scheduleIntakeNotifications({
    required Medication medication,
    required Schedule schedule,
  }) async {
    print('📅 Scheduling notifications for: ${medication.name}');
    
    if (!schedule.isActive) {
      print('⏸️ Schedule is not active, skipping');
      return;
    }
    
    await cancelNotificationsForMedication(medication.id);
    
    final now = DateTime.now();
    final endDate = schedule.endDate;
    final frequencyInDays = _calculateFrequencyInDays(
      schedule.frequencyValue,
      schedule.frequencyUnit,
    );
    
    print('📊 Frequency: every $frequencyInDays days');
    print('📆 Range: ${schedule.startDate} → $endDate');
    
    int scheduledCount = 0;
    
    for (final pattern in schedule.patterns) {
      DateTime currentDate = schedule.startDate;
      
      while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
        if (currentDate.isBefore(DateTime(now.year, now.month, now.day))) {
          currentDate = currentDate.add(Duration(days: frequencyInDays));
          continue;
        }
        
        for (final timeSlot in pattern.dailySlots) {
          final scheduledTime = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            timeSlot.hour,
            timeSlot.minute,
          );
          
          if (scheduledTime.isAfter(now)) {
            await _createIntakeRecordIfNeeded(medication.id, scheduledTime);
            
            await _scheduleReminderNotification(
              medication: medication,
              scheduledTime: scheduledTime,
              pillsCount: pattern.pillsPerSlot,
            );
            
            await _scheduleMainNotification(
              medication: medication,
              scheduledTime: scheduledTime,
              pillsCount: pattern.pillsPerSlot,
            );
            
            await _scheduleFollowUpNotification(
              medication: medication,
              scheduledTime: scheduledTime,
            );
            
            scheduledCount++;
          }
        }
        
        currentDate = currentDate.add(Duration(days: frequencyInDays));
        
        if (currentDate.isAfter(now.add(const Duration(days: 30)))) {
          break;
        }
      }
    }
    
    print('✅ Scheduled $scheduledCount notification sets for ${medication.name}');
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

  Future<void> _scheduleReminderNotification({
    required Medication medication,
    required DateTime scheduledTime,
    required int pillsCount,
  }) async {
    final reminderTime = scheduledTime.subtract(const Duration(minutes: 15));
    
    if (reminderTime.isBefore(DateTime.now())) return;
    if (_isQuietHours(reminderTime)) return;
    
    final notificationId = _getNotificationId(medication.id, scheduledTime, 'reminder');
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Medication Reminders',
      channelDescription: 'Reminders for medication intake',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
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
    
    try {
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
      print('  ⏰ Reminder scheduled for: $reminderTime (ID: $notificationId)');
    } catch (e) {
      print('  ❌ Failed to schedule reminder: $e');
    }
  }

  Future<void> _scheduleMainNotification({
    required Medication medication,
    required DateTime scheduledTime,
    required int pillsCount,
  }) async {
    if (scheduledTime.isBefore(DateTime.now())) return;
    if (_isQuietHours(scheduledTime)) return;
    
    final notificationId = _getNotificationId(medication.id, scheduledTime, 'main');
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Medication Reminders',
      channelDescription: 'Reminders for medication intake',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
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
    
    try {
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
      print('  💊 Main notification scheduled for: $scheduledTime (ID: $notificationId)');
    } catch (e) {
      print('  ❌ Failed to schedule main notification: $e');
    }
  }

  Future<void> _scheduleFollowUpNotification({
    required Medication medication,
    required DateTime scheduledTime,
  }) async {
    final followUpTime = scheduledTime.add(const Duration(minutes: 30));
    
    if (followUpTime.isBefore(DateTime.now())) return;
    if (_isQuietHours(followUpTime)) return;
    
    final notificationId = _getNotificationId(medication.id, scheduledTime, 'followup');
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Medication Reminders',
      channelDescription: 'Reminders for medication intake',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
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
    
    try {
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
      print('  🔔 Follow-up scheduled for: $followUpTime (ID: $notificationId)');
    } catch (e) {
      print('  ❌ Failed to schedule follow-up: $e');
    }
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

  Future<void> showImmediateNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Medication Reminders',
      channelDescription: 'Reminders for medication intake',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
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
    
    try {
      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch % 100000,
        title,
        body,
        details,
        payload: payload,
      );
      print('✅ Test notification sent: $title');
    } catch (e) {
      print('❌ Failed to send test notification: $e');
    }
  }
  
  Future<List<Map<String, dynamic>>> getPendingNotifications() async {
    final pending = await _notifications.pendingNotificationRequests();
    print('📋 Total pending notifications: ${pending.length}');
    
    return pending.map((n) => {
      'id': n.id,
      'title': n.title,
      'body': n.body,
      'payload': n.payload,
    }).toList();
  }
  
  Future<void> printAllPendingNotifications() async {
    final pending = await _notifications.pendingNotificationRequests();
    print('📋 Pending notifications (${pending.length}):');
    
    for (final notification in pending) {
      print('  - ID: ${notification.id}');
      print('    Title: ${notification.title}');
      print('    Body: ${notification.body}');
      print('    Payload: ${notification.payload}');
    }
  }
}
