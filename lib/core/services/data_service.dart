import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../database/database.dart';
import '../models/medication.dart';

class DataService {

  DataService(this._database);
  final AppDatabase _database;

  /// Export all data to JSON file
  Future<File> exportData() async {
    // Get all medications
    final medications = await _database.select(_database.medications).get();
    final schedules = await _database.select(_database.schedules).get();
    final intakeRecords = await _database.select(_database.intakeRecords).get();

    // Create export data structure
    final exportData = {
      'version': '1.0.0',
      'exportDate': DateTime.now().toIso8601String(),
      'medications': medications.map((m) => {
        'id': m.id,
        'name': m.name,
        'dosage': m.dosage,
        'description': m.description,
        'icon': m.icon,
        'createdAt': m.createdAt.toIso8601String(),
        'updatedAt': m.updatedAt.toIso8601String(),
      },).toList(),
      'schedules': schedules.map((s) => {
        'id': s.id,
        'medicationId': s.medicationId,
        'startDate': s.startDate.toIso8601String(),
        'endDate': s.endDate.toIso8601String(),
        'patterns': s.patterns,
        'isActive': s.isActive,
        'createdAt': s.createdAt.toIso8601String(),
      },).toList(),
      'intakeRecords': intakeRecords.map((r) => {
        'id': r.id,
        'medicationId': r.medicationId,
        'scheduledTime': r.scheduledTime.toIso8601String(),
        'actualTime': r.actualTime?.toIso8601String(),
        'status': r.status.name,
        'skipReason': r.skipReason,
        'createdAt': r.createdAt.toIso8601String(),
      },).toList(),
    };

    // Convert to JSON
    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/pillbull_backup_$timestamp.json');
    await file.writeAsString(jsonString);

    return file;
  }

  Future<void> shareData() async {
    final file = await exportData();
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'PillBull Data Backup',
      text: 'My PillBull medication data backup',
    );
  }

  /// Import data from JSON file
  Future<void> importData(File file) async {
    final jsonString = await file.readAsString();
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    await _database.delete(_database.intakeRecords).go();
    await _database.delete(_database.schedules).go();
    await _database.delete(_database.medications).go();

    final medications = data['medications'] as List;
    for (final medData in medications) {
      await _database.into(_database.medications).insert(
        MedicationsCompanion.insert(
          id: medData['id'] as String,
          name: medData['name'] as String,
          dosage: medData['dosage'] as String,
          description: Value(medData['description'] as String?),
          icon: Value(medData['icon'] as String?),
          createdAt: DateTime.parse(medData['createdAt'] as String),
          updatedAt: DateTime.parse(medData['updatedAt'] as String),
        ),
      );
    }

    // Import schedules
    final schedules = data['schedules'] as List;
    for (final schedData in schedules) {
      await _database.into(_database.schedules).insert(
        SchedulesCompanion.insert(
          id: schedData['id'] as String,
          medicationId: schedData['medicationId'] as String,
          startDate: DateTime.parse(schedData['startDate'] as String),
          endDate: DateTime.parse(schedData['endDate'] as String),
          patterns: (schedData['patterns'] as List)
              .map((p) => DosagePatternDto.fromJson(p as Map<String, dynamic>))
              .toList(),
          isActive: Value(schedData['isActive']! as bool),
          createdAt: DateTime.parse(schedData['createdAt'] as String),
        ),
      );
    }

    // Import intake records
    final records = data['intakeRecords'] as List;
    for (final recData in records) {
      await _database.into(_database.intakeRecords).insert(
        IntakeRecordsCompanion.insert(
          id: recData['id'] as String,
          medicationId: recData['medicationId'] as String,
          scheduledTime: DateTime.parse(recData['scheduledTime'] as String),
          actualTime: Value(recData['actualTime'] != null
              ? DateTime.parse(recData['actualTime'] as String)
              : null,),
          status: IntakeStatusDto.values.firstWhere(
            (e) => e.name == recData['status'],
          ),
          skipReason: Value(recData['skipReason'] as String?),
          createdAt: DateTime.parse(recData['createdAt'] as String),
        ),
      );
    }
  }

  /// Clear all data
  Future<void> clearAllData() async {
    await _database.delete(_database.intakeRecords).go();
    await _database.delete(_database.schedules).go();
    await _database.delete(_database.medications).go();
  }
}

