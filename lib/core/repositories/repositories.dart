import 'package:drift/drift.dart';
import '../database/database.dart';
import '../models/medication.dart' hide MedicationDto, IntakeRecordDto;

abstract class MedicationRepository {
  Future<List<Medication>> getAllMedications();
  Future<Medication?> getMedicationById(String id);
  Future<String> createMedication(Medication medication);
  Future<void> updateMedication(Medication medication);
  Future<void> deleteMedication(String id);
}

abstract class ScheduleRepository {
  Future<List<MedicationScheduleDto>> getSchedulesByMedicationId(String medicationId);
  Future<Schedule?> getScheduleById(String id);
  Future<List<MedicationScheduleDto>> getAllActiveSchedules();
  Future<String> createSchedule(MedicationScheduleDto schedule);
  Future<void> updateSchedule(MedicationScheduleDto schedule);
  Future<void> deleteSchedule(String id);
  Future<List<IntakeRecord>> generateScheduleEntries(
    String medicationId,
    DateTime startDate,
    DateTime endDate,
  );
}

abstract class IntakeRecordRepository {
  Future<List<IntakeRecord>> getRecordsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<IntakeRecord>> getRecordsByMedicationId(String medicationId);
  Future<IntakeRecord?> getRecordById(String id);
  Future<String> createRecord(IntakeRecord record);
  Future<void> updateRecord(IntakeRecord record);
  Future<void> deleteRecord(String id);
  Future<List<IntakeRecord>> getRecordsForDate(DateTime date);
}

class MedicationRepositoryImpl implements MedicationRepository {

  MedicationRepositoryImpl(this._database);
  final AppDatabase _database;

  @override
  Future<List<Medication>> getAllMedications() async {
    final query = _database.select(_database.medications);
    final rows = await query.get();
    
    return rows.map((row) => Medication(
      id: row.id,
      name: row.name,
      dosage: row.dosage,
      description: row.description,
      icon: row.icon,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    ),).toList();
  }

  @override
  Future<Medication?> getMedicationById(String id) async {
    final query = _database.select(_database.medications)
      ..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    
    if (row == null) return null;
    
    return Medication(
      id: row.id,
      name: row.name,
      dosage: row.dosage,
      description: row.description,
      icon: row.icon,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  @override
  Future<String> createMedication(Medication medication) async {
    await _database.into(_database.medications).insert(
      MedicationsCompanion.insert(
        id: medication.id,
        name: medication.name,
        dosage: medication.dosage,
        description: Value(medication.description),
        icon: Value(medication.icon),
        createdAt: medication.createdAt,
        updatedAt: medication.updatedAt,
      ),
    );
    return medication.id;
  }

  @override
  Future<void> updateMedication(Medication medication) async {
    await _database.update(_database.medications)
      .replace(MedicationsCompanion(
        id: Value(medication.id),
        name: Value(medication.name),
        dosage: Value(medication.dosage),
        description: Value(medication.description),
        icon: Value(medication.icon),
        createdAt: Value(medication.createdAt),
        updatedAt: Value(medication.updatedAt),
      ),);
  }

  @override
  Future<void> deleteMedication(String id) async {
    await (_database.delete(_database.medications)
      ..where((tbl) => tbl.id.equals(id)))
      .go();
  }
}

class ScheduleRepositoryImpl implements ScheduleRepository {

  ScheduleRepositoryImpl(this._database);
  final AppDatabase _database;

  @override
  Future<List<MedicationScheduleDto>> getSchedulesByMedicationId(String medicationId) async {
    final query = _database.select(_database.schedules)
      ..where((tbl) => tbl.medicationId.equals(medicationId));
    final rows = await query.get();
    
    return rows.map((row) => MedicationScheduleDto(
      id: row.id,
      medicationId: row.medicationId,
      startDate: row.startDate,
      endDate: row.endDate,
      patterns: row.patterns,
      isActive: row.isActive,
      createdAt: row.createdAt,
      frequencyValue: row.frequencyValue,
      frequencyUnit: row.frequencyUnit,
    ),).toList();
  }

  @override
  Future<Schedule?> getScheduleById(String id) async {
    final query = _database.select(_database.schedules)
      ..where((tbl) => tbl.id.equals(id));
    final rows = await query.get();
    return rows.isEmpty ? null : rows.first;
  }

  @override
  Future<List<MedicationScheduleDto>> getAllActiveSchedules() async {
    final query = _database.select(_database.schedules)
      ..where((tbl) => tbl.isActive.equals(true));
    final rows = await query.get();
    
    return rows.map((row) => MedicationScheduleDto(
      id: row.id,
      medicationId: row.medicationId,
      startDate: row.startDate,
      endDate: row.endDate,
      patterns: row.patterns,
      isActive: row.isActive,
      createdAt: row.createdAt,
      frequencyValue: row.frequencyValue,
      frequencyUnit: row.frequencyUnit,
    ),).toList();
  }

  @override
  Future<String> createSchedule(MedicationScheduleDto schedule) async {
    await _database.into(_database.schedules).insert(
      SchedulesCompanion.insert(
        id: schedule.id,
        medicationId: schedule.medicationId,
        startDate: schedule.startDate,
        endDate: schedule.endDate,
        patterns: schedule.patterns,
        createdAt: schedule.createdAt,
        frequencyValue: Value(schedule.frequencyValue),
        frequencyUnit: Value(schedule.frequencyUnit),
      ),
    );
    return schedule.id;
  }

  @override
  Future<void> updateSchedule(MedicationScheduleDto schedule) async {
    await _database.update(_database.schedules)
      .replace(SchedulesCompanion(
        id: Value(schedule.id),
        medicationId: Value(schedule.medicationId),
        startDate: Value(schedule.startDate),
        endDate: Value(schedule.endDate),
        patterns: Value(schedule.patterns),
        isActive: Value(schedule.isActive),
        createdAt: Value(schedule.createdAt),
        frequencyValue: Value(schedule.frequencyValue),
        frequencyUnit: Value(schedule.frequencyUnit),
      ),);
  }

  @override
  Future<void> deleteSchedule(String id) async {
    await (_database.delete(_database.schedules)
      ..where((tbl) => tbl.id.equals(id)))
      .go();
  }

  @override
  Future<List<IntakeRecord>> generateScheduleEntries(
    String medicationId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final schedules = await getSchedulesByMedicationId(medicationId);
    final List<IntakeRecord> records = [];
    
    for (final schedule in schedules) {
      if (!schedule.isActive) {
        continue;
      }
      
      final effectiveStartDate = schedule.startDate.isAfter(startDate) 
          ? schedule.startDate 
          : startDate;
      final effectiveEndDate = schedule.endDate.isBefore(endDate) 
          ? schedule.endDate 
          : endDate;
      
      for (final pattern in schedule.patterns) {
        final patternStartDate = effectiveStartDate.add(Duration(days: pattern.dayStart - 1));
        final patternEndDate = effectiveEndDate.subtract(Duration(days: pattern.dayEnd - 1));
        
        DateTime currentDate = patternStartDate;
        while (currentDate.isBefore(patternEndDate) || currentDate.isAtSameMomentAs(patternEndDate)) {
          for (final timeSlot in pattern.dailySlots) {
            final scheduledTime = timeSlot.toDateTime(currentDate);
            if (scheduledTime.isAfter(effectiveStartDate) && 
                scheduledTime.isBefore(effectiveEndDate)) {
              records.add(IntakeRecord(
                id: '${medicationId}_${scheduledTime.millisecondsSinceEpoch}',
                medicationId: medicationId,
                scheduledTime: scheduledTime,
                status: IntakeStatusDto.scheduled,
                createdAt: DateTime.now(),
              ),);
            }
          }
          currentDate = currentDate.add(const Duration(days: 1));
        }
      }
    }
    
    return records;
  }
}

class IntakeRecordRepositoryImpl implements IntakeRecordRepository {

  IntakeRecordRepositoryImpl(this._database);
  final AppDatabase _database;

  @override
  Future<List<IntakeRecord>> getRecordsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final query = _database.select(_database.intakeRecords)
      ..where((tbl) => 
          tbl.scheduledTime.isBiggerOrEqualValue(startDate) &
          tbl.scheduledTime.isSmallerOrEqualValue(endDate),);
    final rows = await query.get();
    
    return rows.map((row) => IntakeRecord(
      id: row.id,
      medicationId: row.medicationId,
      scheduledTime: row.scheduledTime,
      actualTime: row.actualTime,
      status: row.status,
      skipReason: row.skipReason,
      createdAt: row.createdAt,
    ),).toList();
  }

  @override
  Future<List<IntakeRecord>> getRecordsByMedicationId(String medicationId) async {
    final query = _database.select(_database.intakeRecords)
      ..where((tbl) => tbl.medicationId.equals(medicationId));
    final rows = await query.get();
    
    return rows.map((row) => IntakeRecord(
      id: row.id,
      medicationId: row.medicationId,
      scheduledTime: row.scheduledTime,
      actualTime: row.actualTime,
      status: row.status,
      skipReason: row.skipReason,
      createdAt: row.createdAt,
    ),).toList();
  }

  @override
  Future<IntakeRecord?> getRecordById(String id) async {
    final query = _database.select(_database.intakeRecords)
      ..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    
    if (row == null) {
      return null;
    }
    
    return IntakeRecord(
      id: row.id,
      medicationId: row.medicationId,
      scheduledTime: row.scheduledTime,
      actualTime: row.actualTime,
      status: row.status,
      skipReason: row.skipReason,
      createdAt: row.createdAt,
    );
  }

  @override
  Future<String> createRecord(IntakeRecord record) async {
    await _database.into(_database.intakeRecords).insert(
      IntakeRecordsCompanion.insert(
        id: record.id,
        medicationId: record.medicationId,
        scheduledTime: record.scheduledTime,
        actualTime: Value(record.actualTime),
        status: record.status,
        skipReason: Value(record.skipReason),
        createdAt: record.createdAt,
      ),
    );
    return record.id;
  }

  @override
  Future<void> updateRecord(IntakeRecord record) async {
    await _database.update(_database.intakeRecords)
      .replace(IntakeRecordsCompanion(
        id: Value(record.id),
        medicationId: Value(record.medicationId),
        scheduledTime: Value(record.scheduledTime),
        actualTime: Value(record.actualTime),
        status: Value(record.status),
        skipReason: Value(record.skipReason),
        createdAt: Value(record.createdAt),
      ),);
  }

  @override
  Future<void> deleteRecord(String id) async {
    await (_database.delete(_database.intakeRecords)
      ..where((tbl) => tbl.id.equals(id)))
      .go();
  }

  @override
  Future<List<IntakeRecord>> getRecordsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return getRecordsByDateRange(startOfDay, endOfDay);
  }
}
