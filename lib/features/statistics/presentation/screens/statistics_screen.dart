import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/medication.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../shared/providers/providers.dart';
import '../widgets/statistics_chart.dart';
import '../widgets/adherence_card.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
  }

  void _goToPreviousMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month - 1,
      );
    });
  }

  void _goToNextMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + 1,
      );
    });
  }

  void _goToCurrentMonth() {
    setState(() {
      _selectedMonth = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Calculate date range for selected month
    final startDate = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final endDate = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0, 23, 59, 59);
    
    final medicationsAsync = ref.watch(medicationsProvider);
    final intakeRecordsAsync = ref.watch(
      intakeRecordsForDateRangeProvider(startDate, endDate),
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statistics),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildMonthSelector(l10n),
          Expanded(
            child: medicationsAsync.when(
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
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(AppLocalizations l10n) {
    final now = DateTime.now();
    final isCurrentMonth = _selectedMonth.year == now.year && 
                          _selectedMonth.month == now.month;
    final monthName = _getMonthName(_selectedMonth.month, l10n);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _goToPreviousMonth,
            tooltip: l10n.previousMonth,
          ),
          Expanded(
            child: GestureDetector(
              onTap: isCurrentMonth ? null : _goToCurrentMonth,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: isCurrentMonth 
                      ? AppConstants.primaryColor.withValues(alpha: 0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$monthName ${_selectedMonth.year}',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: isCurrentMonth 
                            ? AppConstants.primaryColor
                            : Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (!isCurrentMonth) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: isCurrentMonth ? null : _goToNextMonth,
            tooltip: l10n.nextMonth,
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month, AppLocalizations l10n) {
    switch (month) {
      case 1: return l10n.january;
      case 2: return l10n.february;
      case 3: return l10n.march;
      case 4: return l10n.april;
      case 5: return l10n.may;
      case 6: return l10n.june;
      case 7: return l10n.july;
      case 8: return l10n.august;
      case 9: return l10n.september;
      case 10: return l10n.october;
      case 11: return l10n.november;
      case 12: return l10n.december;
      default: return '';
    }
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
