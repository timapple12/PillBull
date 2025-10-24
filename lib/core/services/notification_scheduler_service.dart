import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';

/// Service to automatically reschedule notifications
/// - On app resume (from background)
/// - Periodically (every 24 hours)
/// - After device reboot (handled by BootReceiver)
class NotificationSchedulerService {
  NotificationSchedulerService(this._notificationService);
  
  final NotificationService _notificationService;
  Timer? _periodicTimer;
  
  static const String _lastRescheduleKey = 'last_notification_reschedule';
  static const Duration rescheduleInterval = Duration(hours: 24);

  Future<void> initialize() async {
    debugPrint('Initializing NotificationSchedulerService...');
    
    await _checkAndRescheduleIfNeeded();
    
    _startPeriodicCheck();
    
    debugPrint('NotificationSchedulerService initialized');
  }
  
  /// Check if 24 hours have passed since last reschedule
  Future<void> _checkAndRescheduleIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReschedule = prefs.getInt(_lastRescheduleKey);
    
    if (lastReschedule == null) {
      debugPrint('First time launch, scheduling notifications...');
      await _rescheduleAndSaveTimestamp();
      return;
    }
    
    final lastRescheduleTime = DateTime.fromMillisecondsSinceEpoch(lastReschedule);
    final timeSinceLastReschedule = DateTime.now().difference(lastRescheduleTime);
    
    if (timeSinceLastReschedule >= rescheduleInterval) {
      debugPrint('24 hours passed, rescheduling notifications...');
      await _rescheduleAndSaveTimestamp();
    } else {
      final remaining = rescheduleInterval - timeSinceLastReschedule;
      debugPrint('⏳ Next reschedule in ${remaining.inHours}h ${remaining.inMinutes % 60}m');
    }
  }
  
  /// Reschedule all notifications and save timestamp
  Future<void> _rescheduleAndSaveTimestamp() async {
    try {
      await _notificationService.rescheduleAllNotifications();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastRescheduleKey, DateTime.now().millisecondsSinceEpoch);
      
      debugPrint('Notifications rescheduled and timestamp saved');
    } catch (e, stackTrace) {
      debugPrint('Failed to reschedule notifications: $e');
      debugPrint('StackTrace: $stackTrace');
    }
  }
  
  /// Start periodic check (every hour)
  void _startPeriodicCheck() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(const Duration(hours: 1), (timer) {
      debugPrint('Periodic check triggered');
      _checkAndRescheduleIfNeeded();
    });
  }
  
  /// Call this when app resumes from background
  Future<void> onAppResumed() async {
    debugPrint('App resumed, checking if reschedule needed...');
    await _checkAndRescheduleIfNeeded();
  }
  
  /// Call this when app goes to background
  void onAppPaused() {
    debugPrint('App paused');
  }
  
  /// Cleanup resources
  void dispose() {
    _periodicTimer?.cancel();
    debugPrint('NotificationSchedulerService disposed');
  }
}

