import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/database.dart';
import '../../../../core/models/medication.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../shared/providers/notification_provider.dart';
import '../../../../shared/providers/providers.dart';
import '../../../medications/presentation/widgets/add_medication_dialog.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/calendar_header.dart';
import '../widgets/intake_confirmation_dialog.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final calendarState = ref.watch(calendarStateProvider);
    final medicationsAsync = ref.watch(medicationsProvider);
    final schedulesAsync = ref.watch(activeSchedulesProvider);
    final intakeRecordsAsync = ref.watch(
      intakeRecordsForDateRangeProvider(
        _getWeekStartDate(calendarState),
        _getWeekEndDate(calendarState),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              ref.read(calendarStateProvider.notifier).goToToday();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CalendarHeader(
            currentDate: calendarState,
            onPreviousWeek: () {
              ref.read(calendarStateProvider.notifier).goToPreviousWeek();
            },
            onNextWeek: () {
              ref.read(calendarStateProvider.notifier).goToNextWeek();
            },
            onToday: () {
              ref.read(calendarStateProvider.notifier).goToToday();
            },
          ),
          Expanded(
            child: medicationsAsync.when(
              data: (medications) => schedulesAsync.when(
                data: (schedules) => intakeRecordsAsync.when(
                  data: (intakeRecords) => CalendarGrid(
                    medications: medications.map((medication) => medication.toDto()).toList(),
                    schedules: schedules,
                    intakeRecords: intakeRecords.map((intakeRecord) => intakeRecord.toDto()).toList(),
                    startDate: _getWeekStartDate(calendarState),
                    onIntakeTap: (intakeRecord) => _showIntakeConfirmationDialog(intakeRecord.toEntity(), l10n),
                    onCreateIntake: (medication, date) => _createAndShowIntakeDialog(medication, date, l10n),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text('${l10n.error}: $error'),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('${l10n.error}: $error'),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('${l10n.noDataForStatistics}: $error'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMedicationDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  DateTime _getWeekStartDate(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  DateTime _getWeekEndDate(DateTime date) => _getWeekStartDate(date).add(const Duration(days: 6));

  void _showIntakeConfirmationDialog(IntakeRecord record, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => IntakeConfirmationDialog(
        record: record.toDto(),
        onTaken: () => _markAsTaken(record, l10n),
        onSkipped: (reason) => _markAsSkipped(record, reason, l10n),
        onPostponed: (newTime, l10n) => _postponeIntake(record, newTime, l10n),
      ),
    );
  }

  Future<void> _createAndShowIntakeDialog(
    MedicationDto medication,
    DateTime date,
    AppLocalizations l10n,
  ) async {
    final schedules = await ref.read(scheduleRepositoryProvider).getSchedulesByMedicationId(medication.id);
    if (schedules.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noScheduleForMedication)),
        );
      }
      return;
    }
    
    final schedule = schedules.first;
    if (schedule.patterns.isEmpty || schedule.patterns.first.dailySlots.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noScheduleForMedication)),
        );
      }
      return;
    }
    
    final timeSlot = schedule.patterns.first.dailySlots.first;
    
    final scheduledTime = DateTime(
      date.year,
      date.month,
      date.day,
      timeSlot.hour,
      timeSlot.minute,
    );

    // Only show dialog, don't create record yet
    if (mounted) {
      await showDialog(
        context: context,
        builder: (dialogContext) => IntakeConfirmationDialog(
          record: IntakeRecordDto(
            id: const Uuid().v4(),
            medicationId: medication.id,
            scheduledTime: scheduledTime,
            actualTime: null,
            status: IntakeStatusDto.scheduled,
            skipReason: null,
            pillsCount: 1,
            createdAt: DateTime.now(),
          ),
          onTaken: () async {
            try {

              final newRecord = IntakeRecord(
                id: const Uuid().v4(),
                medicationId: medication.id,
                scheduledTime: scheduledTime,
                actualTime: DateTime.now(),
                status: IntakeStatusDto.taken,
                skipReason: null,
                pillsCount: 1,
                createdAt: DateTime.now(),
              );
              
              debugPrint('Creating record with ID: ${newRecord.id}');
              
              final repository = ref.read(intakeRecordRepositoryProvider);
              final recordId = await repository.createRecord(newRecord);
              
              debugPrint('Record created with ID: $recordId');
              
              // Force refresh by invalidating the provider
              ref.invalidate(intakeRecordsForDateRangeProvider);
              

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.medicationMarkedAsTaken)),
                );
              }
              
              debugPrint('UI refresh triggered');
            } catch (e, stackTrace) {
              debugPrint('Error in onTaken: $e');
              debugPrint('StackTrace: $stackTrace');
            }
          },
          onSkipped: (reason) async {
            try {
              debugPrint('onSkipped called for ${medication.name}');
              
              final newRecord = IntakeRecord(
                id: const Uuid().v4(),
                medicationId: medication.id,
                scheduledTime: scheduledTime,
                actualTime: null,
                status: IntakeStatusDto.skipped,
                skipReason: reason,
                pillsCount: 0,
                createdAt: DateTime.now(),
              );
              
              final repository = ref.read(intakeRecordRepositoryProvider);
              await repository.createRecord(newRecord);
              
              debugPrint('Skip record created');
              
              ref.invalidate(intakeRecordsForDateRangeProvider);

              if (mounted) {
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.medicationSkipped)),
                );
              }

            } catch (e, stackTrace) {
              debugPrint(' Error in onSkipped: $e');
              debugPrint('StackTrace: $stackTrace');
            }
          },
          onPostponed: (newTime, l10n) async {
            try {
              debugPrint('onPostponed called for ${medication.name}');
              
              final newRecord = IntakeRecord(
                id: const Uuid().v4(),
                medicationId: medication.id,
                scheduledTime: newTime,
                actualTime: null,
                status: IntakeStatusDto.scheduled,
                skipReason: null,
                pillsCount: 1,
                createdAt: DateTime.now(),
              );
              
              final repository = ref.read(intakeRecordRepositoryProvider);
              await repository.createRecord(newRecord);
              
              debugPrint('Postponed record created');
              
              ref.invalidate(intakeRecordsForDateRangeProvider);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.intakePostponed)),
                );
              }
            } catch (e, stackTrace) {
              debugPrint('Error in onPostponed: $e');
              debugPrint('StackTrace: $stackTrace');
            }
          },
        ),
      );
    }
  }

  void _showAddMedicationDialog() {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AddMedicationDialog(
        onSave: (medication, {startDate, endDate, timeSlots, frequencyValue, frequencyUnit}) async {
          final medicationRepository = ref.read(medicationRepositoryProvider);
          await medicationRepository.createMedication(medication.toEntity());
          
          if (startDate != null && endDate != null && timeSlots != null && timeSlots.isNotEmpty) {
            final scheduleRepository = ref.read(scheduleRepositoryProvider);
            final schedule = MedicationScheduleDto(
              id: const Uuid().v4(),
              medicationId: medication.id,
              startDate: startDate,
              endDate: endDate,
              patterns: [
                DosagePatternDto(
                  dayStart: 1,
                  dayEnd: endDate.difference(startDate).inDays + 1,
                  dailySlots: timeSlots,
                  pillsPerSlot: 1,
                ),
              ],
              isActive: true,
              createdAt: DateTime.now(),
              frequencyValue: frequencyValue ?? 1,
              frequencyUnit: frequencyUnit ?? 'days',
            );
            await scheduleRepository.createSchedule(schedule);
            
            // Schedule notifications
            try {
              final notificationService = ref.read(notificationServiceProvider);
              final scheduleEntity = await scheduleRepository.getScheduleById(schedule.id);
              if (scheduleEntity != null) {
                await notificationService.scheduleIntakeNotifications(
                  medication: medication.toEntity(),
                  schedule: scheduleEntity,
                );
              }
            } catch (e) {
              debugPrint('Failed to schedule notifications: $e');
            }
          }
          
          ref..invalidate(medicationsProvider)
          ..invalidate(activeSchedulesProvider);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.medicationAdded)),
            );
          }
        },
      ),
    );
  }

  Future<void> _markAsTaken(IntakeRecord record, AppLocalizations l10n) async {
    final updatedRecord = record.copyWith(
      status: IntakeStatusDto.taken,
      actualTime: Value(DateTime.now()),
      pillsCount: record.pillsCount + 1,
    );
    
    final repository = ref.read(intakeRecordRepositoryProvider);
    await repository.updateRecord(updatedRecord);
    
    // Force refresh with the specific date range
    ref.invalidate(intakeRecordsForDateRangeProvider);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.medicationMarkedAsTaken)),
      );
    }
  }

  Future<void> _markAsSkipped(IntakeRecord record, String reason, AppLocalizations l10n) async {
    final updatedRecord = record.copyWith(
      status: IntakeStatusDto.skipped,
      skipReason: Value(reason),
    );
    
    final repository = ref.read(intakeRecordRepositoryProvider);
    await repository.updateRecord(updatedRecord);
    
    ref.invalidate(intakeRecordsForDateRangeProvider);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.intakeSkipped)),
      );
    }
  }

  Future<void> _postponeIntake(IntakeRecord record, DateTime newTime, AppLocalizations l10n) async {
    final updatedRecord = record.copyWith(
      scheduledTime: newTime,
      status: IntakeStatusDto.scheduled,
    );
    
    final repository = ref.read(intakeRecordRepositoryProvider);
    await repository.updateRecord(updatedRecord);
    
    ref.invalidate(intakeRecordsForDateRangeProvider);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.intakePostponed)),
      );
    }
  }
}

extension IntakeRecordCopyWith on IntakeRecord {
  IntakeRecord copyWith({
    String? id,
    String? medicationId,
    DateTime? scheduledTime,
    DateTime? actualTime,
    IntakeStatusDto? status,
    String? skipReason,
    int? pillsCount,
    DateTime? createdAt,
  }) => IntakeRecord(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      actualTime: actualTime ?? this.actualTime,
      status: status ?? this.status,
      skipReason: skipReason ?? this.skipReason,
      pillsCount: pillsCount ?? this.pillsCount,
      createdAt: createdAt ?? this.createdAt,
    );
}
