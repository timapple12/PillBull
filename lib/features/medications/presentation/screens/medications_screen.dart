import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/database.dart';
import '../../../../core/models/medication.dart' hide MedicationDto;
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../shared/providers/notification_provider.dart';
import '../../../../shared/providers/providers.dart';
import '../widgets/add_medication_dialog.dart';
import '../widgets/medication_card.dart';

class MedicationsScreen extends ConsumerWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationsAsync = ref.watch(medicationsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.medications),
        centerTitle: true,
      ),
      body: medicationsAsync.when(
        data: (medications) => medications.isEmpty
            ? _buildEmptyState(context, ref, l10n)
            : _buildMedicationsList(medications, ref, context),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('${l10n.error}: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMedicationDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref, AppLocalizations l10n) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medication,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          Text(
            l10n.noMedications,
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            l10n.addMedicationToStart,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          ElevatedButton.icon(
            onPressed: () => _showAddMedicationDialog(context, ref),
            icon: const Icon(Icons.add),
            label: Text(l10n.addMedication),
          ),
        ],
      ),
    );

  Widget _buildMedicationsList(List<Medication> medications, WidgetRef ref, BuildContext context) => ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: medications.length,
      itemBuilder: (context, index) {
        final medication = medications[index];
        return MedicationCard(
          medication: medication.toDto(),
          onEdit: () => _showEditMedicationDialog(context, ref, medication),
          onDelete: () => _showDeleteConfirmation(context, ref, medication),
        );
      },
    );

  void _showAddMedicationDialog(BuildContext context, WidgetRef ref) {
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
          
          ref.invalidate(medicationsProvider);
          ref.invalidate(activeSchedulesProvider);
        },
      ),
    );
  }

  Future<void> _showEditMedicationDialog(
    BuildContext context,
    WidgetRef ref,
    Medication medication,
  ) async {
    final scheduleRepository = ref.read(scheduleRepositoryProvider);
    final schedules = await scheduleRepository.getSchedulesByMedicationId(medication.id);
    final schedule = schedules.isNotEmpty ? schedules.first : null;
    
    if (!context.mounted) {
      return;
    }
    
    await showDialog(
      context: context,
      builder: (context) => AddMedicationDialog(
        medication: medication.toDto(),
        schedule: schedule,
        onSave: (updatedMedication, {startDate, endDate, timeSlots, frequencyValue, frequencyUnit}) async {
          final medicationRepository = ref.read(medicationRepositoryProvider);
          await medicationRepository.updateMedication(updatedMedication.toEntity());
          
          if (startDate != null && endDate != null && timeSlots != null && timeSlots.isNotEmpty) {
            if (schedule != null) {
              final updatedSchedule = schedule.copyWith(
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
                frequencyValue: frequencyValue,
                frequencyUnit: frequencyUnit,
              );
              await scheduleRepository.updateSchedule(updatedSchedule);
              
              // Reschedule notifications
              try {
                final notificationService = ref.read(notificationServiceProvider);
                final scheduleEntity = await scheduleRepository.getScheduleById(updatedSchedule.id);
                if (scheduleEntity != null) {
                  await notificationService.scheduleIntakeNotifications(
                    medication: updatedMedication.toEntity(),
                    schedule: scheduleEntity,
                  );
                }
              } catch (e) {
                debugPrint('Failed to reschedule notifications: $e');
              }
            } else {
              final newSchedule = MedicationScheduleDto(
                id: const Uuid().v4(),
                medicationId: updatedMedication.id,
                startDate: startDate,
                endDate: endDate,
                patterns: [
                  DosagePatternDto(
                    dayStart: 1,
                    dayEnd: (endDate.difference(startDate).inDays + 1),
                    dailySlots: timeSlots,
                    pillsPerSlot: 1,
                  ),
                ],
                isActive: true,
                createdAt: DateTime.now(),
                frequencyValue: frequencyValue ?? 1,
                frequencyUnit: frequencyUnit ?? 'days',
              );
              await scheduleRepository.createSchedule(newSchedule);
              
              // Schedule notifications
              try {
                final notificationService = ref.read(notificationServiceProvider);
                final scheduleEntity = await scheduleRepository.getScheduleById(newSchedule.id);
                if (scheduleEntity != null) {
                  await notificationService.scheduleIntakeNotifications(
                    medication: updatedMedication.toEntity(),
                    schedule: scheduleEntity,
                  );
                }
              } catch (e) {
                debugPrint('Failed to schedule notifications: $e');
              }
            }
          }
          
          ref.invalidate(medicationsProvider);
          ref.invalidate(activeSchedulesProvider);
        },
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Medication medication,
  ) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMedication),
        content: Text(l10n.confirmDeleteMedication(medication.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
              ElevatedButton(
                onPressed: () async {
                  // Cancel notifications
                  try {
                    final notificationService = ref.read(notificationServiceProvider);
                    await notificationService.cancelNotificationsForMedication(medication.id);
                  } catch (e) {
                    debugPrint('Failed to cancel notifications: $e');
                  }
                  
                  final repository = ref.read(medicationRepositoryProvider);
                  await repository.deleteMedication(medication.id);
                  ref.invalidate(medicationsProvider);
                  Navigator.of(context).pop();
                },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.errorColor,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
