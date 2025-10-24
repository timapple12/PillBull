import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/medication.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../shared/providers/providers.dart';
import '../widgets/statistics_chart.dart';
import '../widgets/adherence_card.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationsAsync = ref.watch(medicationsProvider);
    final intakeRecordsAsync = ref.watch(
      intakeRecordsForDateRangeProvider(
        DateTime.now().subtract(const Duration(days: 30)),
        DateTime.now(),
      ),
    );

    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statistics),
        centerTitle: true,
      ),
      body: medicationsAsync.when(
        data: (medications) => intakeRecordsAsync.when(
          data: (intakeRecords) => _buildStatisticsContent(
            context,
            l10n,
            medications.map((medication) => medication.toDto()).toList(),
            intakeRecords.map((intakeRecord) => intakeRecord.toDto()).toList(),
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
    );
  }

  Widget _buildStatisticsContent(
    BuildContext context,
    AppLocalizations l10n,
    List<MedicationDto> medications,
    List<IntakeRecordDto> intakeRecords,
  ) {
    if (medications.isEmpty) {
      return _buildEmptyState(context, l10n);
    }

    final adherenceData = _calculateAdherenceData(intakeRecords);
    final weeklyData = _calculateWeeklyData(intakeRecords);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.overallStatistics,
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildAdherenceCards(adherenceData, l10n),
          const SizedBox(height: AppConstants.paddingLarge),
          Text(
            l10n.weeklyProgress,
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          StatisticsChart(data: weeklyData),
          const SizedBox(height: AppConstants.paddingLarge),
          Text(
            l10n.detailedStatistics,
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildDetailedStats(intakeRecords, l10n),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          Text(
            l10n.noDataForStatistics,
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            l10n.addMedicationsAndStartTaking,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAdherenceCards(Map<String, dynamic> adherenceData, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: AdherenceCard(
            title: l10n.overallAdherence,
            percentage: adherenceData['overall'],
            color: AppConstants.primaryColor,
            icon: Icons.trending_up,
          ),
        ),
        const SizedBox(width: AppConstants.paddingMedium),
        Expanded(
          child: AdherenceCard(
            title: l10n.thisWeek,
            percentage: adherenceData['weekly'],
            color: AppConstants.successColor,
            icon: Icons.calendar_today,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedStats(List<IntakeRecordDto> intakeRecords, AppLocalizations l10n) {
    final statusCounts = <IntakeStatusDto, int>{};

    for (final record in intakeRecords) {
      statusCounts[record.status] = (statusCounts[record.status] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.statusDistribution,
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            ...statusCounts.entries.map((entry) {
              final status = entry.key;
              final count = entry.value;
              final percentage = intakeRecords.isNotEmpty 
                  ? (count / intakeRecords.length * 100).round()
                  : 0;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppUtils.getStatusColor(status.name),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    Expanded(
                      child: Text(AppUtils.getStatusText(status.name, l10n)),
                    ),
                    Text('$count ($percentage%)'),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _calculateAdherenceData(List<IntakeRecordDto> intakeRecords) {
    if (intakeRecords.isEmpty) {
      return {'overall': 0, 'weekly': 0};
    }

    final totalRecords = intakeRecords.length;
    final takenRecords = intakeRecords.where((r) => r.status == IntakeStatusDto.taken).length;
    final overallAdherence = (takenRecords / totalRecords * 100).round();

    // Calculate weekly adherence
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final weeklyRecords = intakeRecords.where((r) => r.scheduledTime.isAfter(weekAgo)).toList();
    final weeklyTaken = weeklyRecords.where((r) => r.status == IntakeStatusDto.taken).length;
    final weeklyAdherence = weeklyRecords.isNotEmpty 
        ? (weeklyTaken / weeklyRecords.length * 100).round()
        : 0;

    return {
      'overall': overallAdherence,
      'weekly': weeklyAdherence,
    };
  }

  List<Map<String, dynamic>> _calculateWeeklyData(List<IntakeRecordDto> intakeRecords) {
    final List<Map<String, dynamic>> weeklyData = [];
    
    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dayRecords = intakeRecords.where((r) {
        return r.scheduledTime.year == date.year &&
               r.scheduledTime.month == date.month &&
               r.scheduledTime.day == date.day;
      }).toList();
      
      final takenCount = dayRecords.where((r) => r.status == IntakeStatusDto.taken).length;
      final adherence = dayRecords.isNotEmpty 
          ? (takenCount / dayRecords.length * 100).round()
          : 0;
      
      weeklyData.add({
        'date': date,
        'adherence': adherence,
        'total': dayRecords.length,
        'taken': takenCount,
      });
    }
    
    return weeklyData;
  }
}
