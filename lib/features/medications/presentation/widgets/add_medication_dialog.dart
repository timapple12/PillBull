import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/medication.dart';
import '../../../../generated/l10n/app_localizations.dart';

class AddMedicationDialog extends ConsumerStatefulWidget {

  const AddMedicationDialog({
    super.key,
    this.medication,
    this.schedule,
    required this.onSave,
  });
  final MedicationDto? medication;
  final MedicationScheduleDto? schedule;
  final Function(MedicationDto medication, {DateTime? startDate, DateTime? endDate, List<TimeSlotDto>? timeSlots, int? frequencyValue, String? frequencyUnit}) onSave;

  @override
  ConsumerState<AddMedicationDialog> createState() => _AddMedicationDialogState();
}

class _AddMedicationDialogState extends ConsumerState<AddMedicationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _descriptionController = TextEditingController();

  int _selectedIconIndex = 0;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isUnlimitedEndDate = false;
  String _frequencyUnit = 'days'; // days, weeks, months
  int _frequencyValue = 1;
  final _frequencyController = TextEditingController(text: '1');
  final List<TimeSlotDto> _timeSlots = [];

  @override
  void initState() {
    super.initState();

    // Set default icon (first one - pills)
    _selectedIconIndex = 0;

    if (widget.medication != null) {
      _nameController.text = widget.medication!.name;
      _dosageController.text = widget.medication!.dosage;
      _descriptionController.text = widget.medication!.description ?? '';

      // Find icon index from stored icon string
      if (widget.medication!.icon != null && widget.medication!.icon!.isNotEmpty) {
        final parsedIndex = int.tryParse(widget.medication!.icon!);
        if (parsedIndex != null && parsedIndex >= 0 && parsedIndex < AppIcons.medicationIcons.length) {
          _selectedIconIndex = parsedIndex;
        }
      }
    }

    if (widget.schedule != null) {
      _startDate = widget.schedule!.startDate;
      _endDate = widget.schedule!.endDate;
      _frequencyValue = widget.schedule!.frequencyValue;
      _frequencyUnit = widget.schedule!.frequencyUnit;
      _frequencyController.text = _frequencyValue.toString();

      _timeSlots.clear();
      for (final pattern in widget.schedule!.patterns) {
        for (final slot in pattern.dailySlots) {
          _timeSlots.add(TimeSlotDto(
            hour: slot.hour,
            minute: slot.minute,
            label: '${slot.hour.toString().padLeft(2, '0')}:${slot.minute.toString().padLeft(2, '0')}',
          ));
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _descriptionController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF2C2838) : const Color(0xFFFAF8F3);
    final headerGradientStart = isDark ? const Color(0xFF3A3548) : const Color(0xFFE8DFF5);
    final headerGradientEnd = isDark ? const Color(0xFF4A4458) : const Color(0xFFFCE7F3);
    final footerColor = isDark ? const Color(0xFF3A3548) : Colors.white;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 650),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    headerGradientStart,
                    headerGradientEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.medication != null ? Icons.edit : Icons.add,
                      color: AppConstants.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: Text(
                      widget.medication != null ? l10n.editMedication : l10n.addMedication,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: isDark ? const Color(0xFFE8DFF5) : const Color(0xFF4A4458),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBasicInfoSection(l10n),
                      const SizedBox(height: AppConstants.paddingLarge),
                      _buildScheduleSection(l10n),
                      const SizedBox(height: AppConstants.paddingSmall),
                      _buildIconSelector(l10n),
                    ],
                  ),
                ),
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              decoration: BoxDecoration(
                color: footerColor.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppConstants.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  ElevatedButton(
                    onPressed: _saveMedication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(widget.medication != null ? l10n.update : l10n.add),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(AppLocalizations l10n) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.basicInformation,
          style: AppTextStyles.titleMedium,
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: l10n.medicationName,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.enterMedicationName;
            }
            return null;
          },
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        TextFormField(
          controller: _dosageController,
          decoration: InputDecoration(
            labelText: l10n.dosage,
            border: const OutlineInputBorder(),
            hintText: l10n.dosageHint,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.enterDosage;
            }
            return null;
          },
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: l10n.descriptionOptional,
            border: const OutlineInputBorder(),
            hintText: l10n.additionalNotes,
          ),
          maxLines: 2,
        ),
      ],
    );

  Widget _buildIconSelector(AppLocalizations l10n) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.icon),
        const SizedBox(height: AppConstants.paddingSmall),
        Wrap(
          spacing: AppConstants.paddingSmall,
          runSpacing: AppConstants.paddingSmall,
          children: AppIcons.medicationIcons.asMap().entries.map((entry) {
            final index = entry.key;
            final icon = entry.value;
            final isSelected = _selectedIconIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIconIndex = index;
                });
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? AppConstants.primaryColor : Colors.grey[300]!,
                    width: isSelected ? 2.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  color: isSelected ? AppConstants.primaryColor.withValues(alpha: 0.15) : null,
                ),
                child: Center(
                  child: FaIcon(
                    icon,
                    size: 24,
                    color: isSelected ? AppConstants.primaryColor : Colors.grey[700],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );

  Widget _buildScheduleSection(AppLocalizations l10n) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.intakeSchedule,
          style: AppTextStyles.titleMedium,
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        _buildFrequencySelector(l10n),
        const SizedBox(height: AppConstants.paddingMedium),
        _buildDateRangeSelector(l10n),
        const SizedBox(height: AppConstants.paddingSmall),
        _buildQuickDateFilters(l10n),
        const SizedBox(height: AppConstants.paddingMedium),
        _buildTimeSlotsSection(l10n),
      ],
    );

  Widget _buildDateRangeSelector(AppLocalizations l10n) => Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              FocusScope.of(context).unfocus();
              final date = await showDatePicker(
                context: context,
                initialDate: _startDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
              );
              if (date != null && mounted) {
                setState(() {
                  _startDate = date;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.startDate),
                  Text(
                    _startDate != null
                        ? AppUtils.formatDate(_startDate!, l10n)
                        : l10n.selectDate,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _startDate != null ? null : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppConstants.paddingMedium),
        Expanded(
          child: Column(
            children: [
              InkWell(
                onTap: _isUnlimitedEndDate ? null : () async {
                  FocusScope.of(context).unfocus();
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _endDate ??
                        DateTime.now().add(const Duration(days: 30)),
                    firstDate: _startDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (date != null && mounted) {
                    setState(() {
                      _endDate = date;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    color: _isUnlimitedEndDate ? Colors.grey[100] : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.endDate),
                      Text(
                        _isUnlimitedEndDate
                            ? l10n.unlimited
                            : (_endDate != null
                                ? AppUtils.formatDate(_endDate!, l10n)
                                : l10n.selectDate),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: _endDate != null || _isUnlimitedEndDate
                              ? null
                              : Colors.grey[500],
                        ),
                      ),
                  ],
                ),
              ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildQuickDateFilters(AppLocalizations l10n) => Wrap(
      spacing: AppConstants.paddingSmall,
      children: [
        _buildQuickFilterChip(l10n.oneWeek, 7),
        _buildQuickFilterChip(l10n.twoWeeks, 14),
        _buildQuickFilterChip(l10n.oneMonth, 30),
        _buildQuickFilterChip(l10n.unlimited, 365 * 100),
      ],
    );

  Widget _buildQuickFilterChip(String label, int days) => ActionChip(
      label: Text(label, style: AppTextStyles.labelSmall),
      onPressed: () {
        final now = DateTime.now();
        setState(() {
          // Always set start date to today when using quick filter
          _startDate = DateTime(now.year, now.month, now.day);
          _endDate = _startDate!.add(Duration(days: days));
          _isUnlimitedEndDate = false;
        });
      },
      backgroundColor: AppConstants.secondaryColor,
      padding: EdgeInsets.zero,
    );

  Widget _buildFrequencySelector(AppLocalizations l10n) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.frequency, style: AppTextStyles.titleSmall),
        const SizedBox(height: AppConstants.paddingSmall),
        Row(
          children: [
            Text(l10n.everyNDays(0).split(' ')[0]), // "Every" or "Кожні"
            const SizedBox(width: AppConstants.paddingSmall),
            SizedBox(
              width: 70,
              child: TextFormField(
                controller: _frequencyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingSmall,
                    vertical: AppConstants.paddingSmall,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                ),
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  if (parsed != null && parsed > 0) {
                    setState(() {
                      _frequencyValue = parsed;
                    });
                  }
                },
                validator: (value) {
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed < 1) {
                    return l10n.enterMedicationName; // Reuse or add new key
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _frequencyUnit,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingSmall,
                    vertical: AppConstants.paddingSmall,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'days',
                    child: Text(_frequencyValue == 1 ? l10n.daily.toLowerCase() : 'днів'),
                  ),
                  DropdownMenuItem(
                    value: 'weeks',
                    child: Text(_frequencyValue == 1 ? l10n.weekly.toLowerCase() : 'тижнів'),
                  ),
                  DropdownMenuItem(
                    value: 'months',
                    child: Text(_frequencyValue == 1 ? l10n.monthly.toLowerCase() : 'місяців'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _frequencyUnit = value;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _getFrequencyDescription(l10n),
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );

  String _getFrequencyDescription(AppLocalizations l10n) {
    if (_frequencyValue == 1) {
      switch (_frequencyUnit) {
        case 'days':
          return l10n.daily; // "Daily" or "Щодня"
        case 'weeks':
          return l10n.weekly; // "Weekly" or "Щотижня"
        case 'months':
          return l10n.monthly; // "Monthly" or "Щомісяця"
      }
    }

    switch (_frequencyUnit) {
      case 'days':
        return 'Кожні $_frequencyValue днів';
      case 'weeks':
        return 'Кожні $_frequencyValue тижнів';
      case 'months':
        return 'Кожні $_frequencyValue місяців';
    }
    return '';
  }

  Widget _buildTimeSlotsSection(AppLocalizations l10n) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.intakeTime),
            TextButton.icon(
              onPressed: _addTimeSlot,
              icon: const Icon(Icons.add),
              label: Text(l10n.addTime),
            ),
          ],
        ),
        if (_timeSlots.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.access_time,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                Text(
                  l10n.addIntakeTime,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        else
          ..._timeSlots.asMap().entries.map((entry) {
            final index = entry.key;
            final timeSlot = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _editTimeSlot(index),
                      child: Container(
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: AppConstants.paddingSmall),
                            Text(timeSlot.label),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  IconButton(
                    onPressed: () => _removeTimeSlot(index),
                    icon: const Icon(Icons.delete),
                    color: AppConstants.errorColor,
                  ),
                ],
              ),
            );
          }).toList(),
      ],
    );

  void _addTimeSlot() async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (time != null) {
      final timeSlot = TimeSlotDto(
        hour: time.hour,
        minute: time.minute,
        label: '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
      );

      setState(() {
        _timeSlots.add(timeSlot);
      });
    }
  }

  void _editTimeSlot(int index) async {
    final currentSlot = _timeSlots[index];
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: currentSlot.hour, minute: currentSlot.minute),
    );

    if (time != null) {
      final updatedSlot = TimeSlotDto(
        hour: time.hour,
        minute: time.minute,
        label: '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
      );

      setState(() {
        _timeSlots[index] = updatedSlot;
      });
    }
  }

  void _removeTimeSlot(int index) {
    setState(() {
      _timeSlots.removeAt(index);
    });
  }

  void _showErrorSnackBar(String message) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppConstants.errorColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 3), entry.remove);
  }

  void _saveMedication() {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startDate == null) {
      _showErrorSnackBar(l10n.selectStartEndDates);
      return;
    }

    if (!_isUnlimitedEndDate && _endDate == null) {
      _showErrorSnackBar(l10n.selectStartEndDates);
      return;
    }

    if (_timeSlots.isEmpty) {
      _showErrorSnackBar(l10n.addAtLeastOneTime);
      return;
    }

    final medication = MedicationDto(
      id: widget.medication?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      dosage: _dosageController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      icon: _selectedIconIndex.toString(),
      createdAt: widget.medication?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    debugPrint('Saving medication with icon index: $_selectedIconIndex');

    widget.onSave(
      medication,
      startDate: _startDate,
      endDate: _endDate,
      timeSlots: List.from(_timeSlots),
      frequencyValue: _frequencyValue,
      frequencyUnit: _frequencyUnit,
    );
    Navigator.of(context).pop();
  }
}

