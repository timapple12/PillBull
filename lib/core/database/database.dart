import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import '../models/medication.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Medications, Schedules, IntakeRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
  );
}

LazyDatabase _openConnection() => LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pillbull.db'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });

class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get dosage => text()();
  TextColumn get description => text().nullable()();
  TextColumn get icon => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Schedules extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId => text().references(Medications, #id)();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get patterns => text().map(const DosagePatternListConverter())();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class IntakeRecords extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId => text().references(Medications, #id)();
  DateTimeColumn get scheduledTime => dateTime()();
  DateTimeColumn get actualTime => dateTime().nullable()();
  TextColumn get status => text().map(const IntakeStatusConverter())();
  TextColumn get skipReason => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class DosagePatternListConverter extends TypeConverter<List<DosagePatternDto>, String> {
  const DosagePatternListConverter();

  @override
  List<DosagePatternDto> fromSql(String fromDb) {
    final List<dynamic> jsonList = jsonDecode(fromDb);
    return jsonList
        .map((json) => DosagePatternDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  String toSql(List<DosagePatternDto> value) {
    final List<Map<String, dynamic>> jsonList =
    value.map((pattern) => pattern.toJson()).toList();
    return jsonEncode(jsonList);
  }
}

class IntakeStatusConverter extends TypeConverter<IntakeStatusDto, String> {
  const IntakeStatusConverter();

  @override
  IntakeStatusDto fromSql(String fromDb) => IntakeStatusDto.values.firstWhere(
      (status) => status.name == fromDb,
      orElse: () => IntakeStatusDto.scheduled,
    );

  @override
  String toSql(IntakeStatusDto value) => value.name;
}
