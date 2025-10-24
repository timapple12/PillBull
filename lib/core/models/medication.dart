import 'package:drift/drift.dart';

import '../database/database.dart';

//part 'medication.g.dart';

@DataClassName('MedicationDto')
class MedicationDto {
  const MedicationDto({
    required this.id,
    required this.name,
    required this.dosage,
    this.description,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MedicationDto.fromJson(Map<String, dynamic> json) => MedicationDto(
        id: json['id'] as String,
        name: json['name'] as String,
        dosage: json['dosage'] as String,
        description: json['description'] as String?,
        icon: json['icon'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
  final String id;
  final String name;
  final String dosage;
  final String? description;
  final String? icon;
  final DateTime createdAt;
  final DateTime updatedAt;

  MedicationDto copyWith({
    String? id,
    String? name,
    String? dosage,
    String? description,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      MedicationDto(
        id: id ?? this.id,
        name: name ?? this.name,
        dosage: dosage ?? this.dosage,
        description: description ?? this.description,
        icon: icon ?? this.icon,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dosage': dosage,
        'description': description,
        'icon': icon,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  Medication toEntity() => Medication(
        id: id,
        name: name,
        dosage: dosage,
        description: description,
        icon: icon,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

extension MedicationMapper on Medication {
  MedicationDto toDto() => MedicationDto(
        id: id,
        name: name,
        dosage: dosage,
        description: description,
        icon: icon,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

enum IntakeStatusDto {
  scheduled,
  taken,
  missed,
  skipped,
}

@DataClassName('DosagePatternDto')
class DosagePatternDto {
  const DosagePatternDto({
    required this.dayStart,
    required this.dayEnd,
    required this.dailySlots,
    required this.pillsPerSlot,
  });

  factory DosagePatternDto.fromJson(Map<String, dynamic> json) =>
      DosagePatternDto(
        dayStart: json['dayStart'] as int,
        dayEnd: json['dayEnd'] as int,
        dailySlots: (json['dailySlots'] as List)
            .map((slot) => TimeSlotDto.fromJson(slot as Map<String, dynamic>))
            .toList(),
        pillsPerSlot: json['pillsPerSlot'] as int,
      );
  final int dayStart;
  final int dayEnd;
  final List<TimeSlotDto> dailySlots;
  final int pillsPerSlot;

  Map<String, dynamic> toJson() => {
        'dayStart': dayStart,
        'dayEnd': dayEnd,
        'dailySlots': dailySlots.map((slot) => slot.toJson()).toList(),
        'pillsPerSlot': pillsPerSlot,
      };
}

@DataClassName('TimeSlotDto')
class TimeSlotDto {
  const TimeSlotDto({
    required this.hour,
    required this.minute,
    required this.label,
  });

  factory TimeSlotDto.fromJson(Map<String, dynamic> json) => TimeSlotDto(
        hour: json['hour'] as int,
        minute: json['minute'] as int,
        label: json['label'] as String,
      );
  final int hour;
  final int minute;
  final String label;

  Map<String, dynamic> toJson() => {
        'hour': hour,
        'minute': minute,
        'label': label,
      };

  DateTime toDateTime(DateTime date) =>
      DateTime(date.year, date.month, date.day, hour, minute);
}

@DataClassName('MedicationScheduleDto')
class MedicationScheduleDto {
  const MedicationScheduleDto({
    required this.id,
    required this.medicationId,
    required this.startDate,
    required this.endDate,
    required this.patterns,
    required this.isActive,
    required this.createdAt,
    this.frequencyValue = 1,
    this.frequencyUnit = 'days',
  });

  factory MedicationScheduleDto.fromJson(Map<String, dynamic> json) =>
      MedicationScheduleDto(
        id: json['id'] as String,
        medicationId: json['medicationId'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
        patterns: (json['patterns'] as List)
            .map(
              (pattern) =>
                  DosagePatternDto.fromJson(pattern as Map<String, dynamic>),
            )
            .toList(),
        isActive: json['isActive'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
        frequencyValue: json['frequencyValue'] as int? ?? 1,
        frequencyUnit: json['frequencyUnit'] as String? ?? 'days',
      );
  final String id;
  final String medicationId;
  final DateTime startDate;
  final DateTime endDate;
  final List<DosagePatternDto> patterns;
  final bool isActive;
  final DateTime createdAt;
  final int frequencyValue;
  final String frequencyUnit;

  Map<String, dynamic> toJson() => {
        'id': id,
        'medicationId': medicationId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'patterns': patterns.map((pattern) => pattern.toJson()).toList(),
        'isActive': isActive,
        'createdAt': createdAt.toIso8601String(),
        'frequencyValue': frequencyValue,
        'frequencyUnit': frequencyUnit,
      };

  MedicationScheduleDto copyWith({
      DateTime? startDate,
      DateTime? endDate,
      List<DosagePatternDto>? patterns,
      int? frequencyValue,
      String? frequencyUnit,
    }) => MedicationScheduleDto(
      id: id,
      medicationId: medicationId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      patterns: patterns ?? this.patterns,
      isActive: isActive,
      createdAt: createdAt,
      frequencyValue: frequencyValue ?? this.frequencyValue,
      frequencyUnit: frequencyUnit ?? this.frequencyUnit,
    );
}

@DataClassName('IntakeRecordDto')
class IntakeRecordDto {
  const IntakeRecordDto({
    required this.id,
    required this.medicationId,
    required this.scheduledTime,
    this.actualTime,
    required this.status,
    this.skipReason,
    required this.createdAt,
  });

  factory IntakeRecordDto.fromJson(Map<String, dynamic> json) =>
      IntakeRecordDto(
        id: json['id'] as String,
        medicationId: json['medicationId'] as String,
        scheduledTime: DateTime.parse(json['scheduledTime'] as String),
        actualTime: json['actualTime'] != null
            ? DateTime.parse(json['actualTime'] as String)
            : null,
        status: IntakeStatusDto.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => IntakeStatusDto.scheduled,
        ),
        skipReason: json['skipReason'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
  final String id;
  final String medicationId;
  final DateTime scheduledTime;
  final DateTime? actualTime;
  final IntakeStatusDto status;
  final String? skipReason;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'medicationId': medicationId,
        'scheduledTime': scheduledTime.toIso8601String(),
        'actualTime': actualTime?.toIso8601String(),
        'status': status.name,
        'skipReason': skipReason,
        'createdAt': createdAt.toIso8601String(),
      };

  IntakeRecord toEntity() => IntakeRecord(
        id: id,
        medicationId: medicationId,
        scheduledTime: scheduledTime,
        status: status,
        createdAt: createdAt,
      );
}

extension IntakeRecordMapper on IntakeRecord {
  IntakeRecordDto toDto() => IntakeRecordDto(
      id: id,
      medicationId: medicationId,
      scheduledTime: scheduledTime,
      status: status,
      createdAt: createdAt);
}
