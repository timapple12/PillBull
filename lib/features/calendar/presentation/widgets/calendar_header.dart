import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../generated/l10n/app_localizations.dart';

class CalendarHeader extends StatelessWidget {

  const CalendarHeader({
    super.key,
    required this.currentDate,
    required this.onPreviousWeek,
    required this.onNextWeek,
    required this.onToday,
  });
  final DateTime currentDate;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPreviousWeek,
            icon: const Icon(Icons.chevron_left),
            style: IconButton.styleFrom(
              backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.1),
            ),
          ),
          GestureDetector(
            onTap: onToday,
            child: Column(
              children: [
                Text(
                  '${AppUtils.getMonthName(currentDate, l10n)} ${currentDate.year}',
                  style: AppTextStyles.titleLarge,
                ),
                Text(
                  '${l10n.week} ${AppUtils.getWeekNumber(currentDate)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onNextWeek,
            icon: const Icon(Icons.chevron_right),
            style: IconButton.styleFrom(
              backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
