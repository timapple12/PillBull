import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../core/models/medication.dart';

class CalendarCell extends StatelessWidget {

  const CalendarCell({
    super.key,
    required this.records,
    required this.medication,
    required this.date,
    required this.isInScheduleRange,
    this.onTap,
  });
  final List<IntakeRecordDto> records;
  final MedicationDto medication;
  final DateTime date;
  final bool isInScheduleRange;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isToday = AppUtils.isToday(date);
    final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
    
    if (!isInScheduleRange) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        ),
      );
    }
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(3),
        constraints: const BoxConstraints(minHeight: 48),
        decoration: BoxDecoration(
          color: _getCellColor(),
          border: Border.all(
            color: isToday ? AppConstants.primaryColor : Colors.grey[300]!,
            width: isToday ? 2.5 : 1.5,
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall + 2),
          boxShadow: records.isNotEmpty
              ? [
                  BoxShadow(
                    color: _getCellColor().withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (records.isNotEmpty) ...[
              _buildStatusIcon(),
              const SizedBox(height: 4),
              _buildPillsCount(),
              if (records.length > 1) ...[
                const SizedBox(height: 2),
                _buildMultipleIndicator(),
              ],
            ] else if (!isPast) ...[
              Icon(
                Icons.add_circle_outline,
                size: 20,
                color: Colors.grey[400],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    final status = records.first.status;
    
    switch (status) {
      case IntakeStatusDto.taken:
        return const Icon(
          Icons.check_circle,
          color: AppConstants.successColor,
          size: 20,
        );
      case IntakeStatusDto.missed:
        return const Icon(
          Icons.cancel,
          color: AppConstants.errorColor,
          size: 20,
        );
      case IntakeStatusDto.skipped:
        return const Icon(
          Icons.schedule,
          color: AppConstants.warningColor,
          size: 20,
        );
      case IntakeStatusDto.scheduled:
        return const Icon(
          Icons.radio_button_unchecked,
          color: AppConstants.primaryColor,
          size: 20,
        );
    }
  }

  Widget _buildPillsCount() {
    final totalPills = records.fold<int>(
      0,
      (sum, record) => sum + _getPillsCountForRecord(record),
    );
    
    if (totalPills > 0) {
      return Text(
        totalPills.toString(),
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.bold,
          color: _getTextColor(),
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildMultipleIndicator() {
    if (records.length > 1) {
      return Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(
          color: AppConstants.primaryColor,
          shape: BoxShape.circle,
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

  Color _getCellColor() {
    if (records.isEmpty) {
      return Colors.transparent;
    }
    
    final status = records.first.status;
    return AppUtils.getStatusColor(status.name);
  }

  Color _getTextColor() {
    if (records.isEmpty) {
      return Colors.grey[400]!;
    }
    
    final status = records.first.status;
    switch (status) {
      case IntakeStatusDto.taken:
        return AppConstants.successColor;
      case IntakeStatusDto.missed:
        return AppConstants.errorColor;
      case IntakeStatusDto.skipped:
        return AppConstants.warningColor;
      case IntakeStatusDto.scheduled:
        return AppConstants.primaryColor;
    }
  }

  int _getPillsCountForRecord(IntakeRecordDto record) {
    // This would typically come from the schedule pattern
    // For now, return a default value
    return 1;
  }
}
