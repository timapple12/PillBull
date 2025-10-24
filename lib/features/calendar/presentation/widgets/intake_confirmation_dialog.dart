import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/medication.dart';
import '../../../../generated/l10n/app_localizations.dart';

class IntakeConfirmationDialog extends StatefulWidget {

  const IntakeConfirmationDialog({
    super.key,
    required this.record,
    required this.onTaken,
    required this.onSkipped,
    required this.onPostponed,
    required this.onMissed,
  });
  final IntakeRecordDto record;
  final VoidCallback onTaken;
  final VoidCallback onMissed;
  final Function(String reason) onSkipped;
  final Function(DateTime newTime, AppLocalizations l10n) onPostponed;

  @override
  State<IntakeConfirmationDialog> createState() =>
      _IntakeConfirmationDialogState();
}

class _IntakeConfirmationDialogState extends State<IntakeConfirmationDialog> {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final skipReasons = [
      l10n.skipReasonForgot,
      l10n.skipReasonNoMedicine,
      l10n.skipReasonFeelBad,
      l10n.skipReasonOther,
    ];

    return AlertDialog(
      title: Text(l10n.confirmIntake),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.scheduledTime}: ${AppUtils.formatDateTime(widget.record.scheduledTime, l10n)}',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(l10n.chooseAction),
        ],
      ),
      actions: [
        if (widget.record.status != IntakeStatusDto.scheduled)
          TextButton(
            onPressed: () => _showResetDialog(l10n),
            child: Text(l10n.reset),
          ),
        ElevatedButton(
          onPressed: () {
            widget.onTaken();
            Navigator.of(context).pop();
          },
          child: Text(l10n.taken),
        ),
        FilledButton(
          onPressed: () {
            widget.onMissed();
            Navigator.of(context).pop();
          },
          child: Text(l10n.missed),
        ),
        TextButton(
          onPressed: () => _showPostponeDialog(l10n),
          child: Text(l10n.postponeIntake),
        ),
        TextButton(
          onPressed: () => _showSkipDialog(l10n, skipReasons),
          child: Text(l10n.skipIntake),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }

  void _showSkipDialog(AppLocalizations l10n, List<String> skipReasons) {
    String? tempSelectedReason;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.skipReason),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: skipReasons.map((reason) => RadioListTile<String>(
              title: Text(reason),
              value: reason,
              groupValue: tempSelectedReason,
              onChanged: (value) {
                setDialogState(() {
                  tempSelectedReason = value;
                });
              },
            )).toList(),
          ),
          actions: [
            ElevatedButton(
              onPressed: tempSelectedReason != null
                  ? () {
                      widget.onSkipped(tempSelectedReason!);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  : null,
              child: Text(l10n.confirm),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostponeDialog(AppLocalizations l10n) {
    DateTime? selectedTime;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.postponeIntake),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.selectNewTime),
              const SizedBox(height: AppConstants.paddingMedium),
              ElevatedButton(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(
                      widget.record.scheduledTime,
                    ),
                  );
                  if (time != null) {
                    final newDateTime = DateTime(
                      widget.record.scheduledTime.year,
                      widget.record.scheduledTime.month,
                      widget.record.scheduledTime.day,
                      time.hour,
                      time.minute,
                    );
                    setDialogState(() {
                      selectedTime = newDateTime;
                    });
                  }
                },
                child: Text(
                  selectedTime != null
                      ? AppUtils.formatTime(selectedTime!)
                      : l10n.selectTime,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: selectedTime != null
                  ? () {
                widget.onPostponed(selectedTime!, l10n);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
                  : null,
              child: Text(l10n.postponeIntake),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetIntake),
        content: Text(l10n.confirmResetIntake),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Reset to scheduled status by calling onPostponed with original time
              widget.onPostponed(widget.record.scheduledTime, l10n);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(l10n.reset),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}
