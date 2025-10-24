import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../generated/l10n/app_localizations.dart';


class StatisticsChart extends StatelessWidget {

  const StatisticsChart({
    super.key,
    required this.data,
  });
  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.adherenceByDays,
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: data.map((dayData) {
                  final adherence = dayData['adherence'] as int;
                  final date = dayData['date'] as DateTime;
                  final isToday = AppUtils.isToday(date);

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          adherence.toString(),
                          style: AppTextStyles.labelSmall,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: isToday
                                ? AppConstants.primaryColor
                                : AppConstants.primaryColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                          ),
                          height: (adherence / 100) * 150,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppUtils.getWeekdayName(date, l10n),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isToday ? AppConstants.primaryColor : null,
                            fontWeight: isToday ? FontWeight.bold : null,
                          ),
                        ),
                        Text(
                          date.day.toString(),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isToday ? AppConstants.primaryColor : null,
                            fontWeight: isToday ? FontWeight.bold : null,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            _buildLegend(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(AppLocalizations l10n) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          l10n.adherencePercentage,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
}
