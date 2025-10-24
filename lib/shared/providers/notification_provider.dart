import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/notification_scheduler_service.dart';
import '../../core/services/notification_service.dart';
import 'providers.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return NotificationService(database);
});

final notificationSchedulerServiceProvider = Provider<NotificationSchedulerService>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return NotificationSchedulerService(notificationService);
});


