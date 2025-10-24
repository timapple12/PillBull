import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/medication.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../widgets/calendar_cell.dart';

class CalendarGrid extends StatelessWidget {

  const CalendarGrid({
    super.key,
    required this.medications,
    required this.schedules,
    required this.intakeRecords,
    required this.startDate,
    required this.onIntakeTap,
    required this.onCreateIntake,
  });
  final List<MedicationDto> medications;
  final List<MedicationScheduleDto> schedules;
  final List<IntakeRecordDto> intakeRecords;
  final DateTime startDate;
  final Function(IntakeRecordDto) onIntakeTap;
  final Function(MedicationDto medication, DateTime date) onCreateIntake;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        children: [
          _buildDateHeaders(l10n),
          Expanded(
            child: _buildMedicationRows(l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeaders(AppLocalizations l10n) => Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 2),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Center(
              child: Text(
                l10n.medications,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                  fontSize: 11,
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: List.generate(AppConstants.daysToShow, (index) {
                final date = startDate.add(Duration(days: index));
                final isToday = AppUtils.isToday(date);

                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingMedium + 2,
                      horizontal: 2,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: isToday ? AppConstants.primaryColor.withValues(alpha: 0.15) : Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      border: Border.all(
                        color: isToday ? AppConstants.primaryColor : Colors.grey[300]!,
                        width: isToday ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            AppUtils.getWeekdayName(date, l10n),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: isToday ? AppConstants.primaryColor : Colors.grey[700],
                              fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date.day.toString(),
                          style: AppTextStyles.titleLarge.copyWith(
                            color: isToday ? AppConstants.primaryColor : Colors.grey[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );

  Widget _buildMedicationRows(AppLocalizations l10n) {
    if (medications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medication,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              l10n.noMedications,
              style: AppTextStyles.titleMedium.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              l10n.addMedicationToStart,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: medications.length,
      itemBuilder: (context, medicationIndex) {
        final medication = medications[medicationIndex];
        return _buildMedicationRow(medication, l10n);
      },
    );
  }

  Widget _buildMedicationRow(MedicationDto medication, AppLocalizations l10n) => Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 130,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingSmall,
                vertical: AppConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (medication.icon != null) ...[
                    FaIcon(
                      _getIconData(medication.icon!),
                      size: 18,
                      color: AppConstants.primaryColor,
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    medication.name,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    medication.dosage,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Expanded(
              child: Row(
              children: List.generate(AppConstants.daysToShow, (dayIndex) {
                final date = startDate.add(Duration(days: dayIndex));
                final isInScheduleRange = _isDateInMedicationSchedule(
                  medication.id,
                  date,
                );
                
                final recordsForDay = isInScheduleRange
                    ? _getRecordsForMedicationAndDate(
                        medication.id,
                        date,
                      )
                    : <IntakeRecordDto>[];

                return Expanded(
                  child: CalendarCell(
                    records: recordsForDay,
                    medication: medication,
                    date: date,
                    isInScheduleRange: isInScheduleRange,
                    onTap: isInScheduleRange
                        ? () {
                            if (recordsForDay.isNotEmpty) {
                              onIntakeTap(recordsForDay.first);
                            } else {
                              onCreateIntake(medication, date);
                            }
                          }
                        : null,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    ),
  );

  bool _isDateInMedicationSchedule(String medicationId, DateTime date) {
    // Find schedules for this medication
    final medicationSchedules = schedules.where(
      (schedule) => schedule.medicationId == medicationId,
    );
    
    // If no schedules found, don't show cells
    if (medicationSchedules.isEmpty) {
      return false;
    }
    
    // Check if date is within any active schedule range
    for (final schedule in medicationSchedules) {
      final startDate = DateTime(
        schedule.startDate.year,
        schedule.startDate.month,
        schedule.startDate.day,
      );
      final endDate = DateTime(
        schedule.endDate.year,
        schedule.endDate.month,
        schedule.endDate.day,
        23, // End of day
        59,
        59,
      );
      final checkDate = DateTime(
        date.year,
        date.month,
        date.day,
      );
      
      // Check if date is within schedule range
      if (!checkDate.isBefore(startDate) && !checkDate.isAfter(endDate)) {
        return true;
      }
    }
    
    return false;
  }

  List<IntakeRecordDto> _getRecordsForMedicationAndDate(
    String medicationId,
    DateTime date,
  ) => intakeRecords.where((record) => record.medicationId == medicationId &&
             record.scheduledTime.year == date.year &&
             record.scheduledTime.month == date.month &&
             record.scheduledTime.day == date.day,).toList();

  IconData _getIconData(String iconString) {
    final iconIndex = int.tryParse(iconString);
    if (iconIndex != null && iconIndex >= 0 && iconIndex < AppIcons.medicationIcons.length) {
      return AppIcons.medicationIcons[iconIndex];
    }
    return FontAwesomeIcons.pills; // Default icon
  }
}
