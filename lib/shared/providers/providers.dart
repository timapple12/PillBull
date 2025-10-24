import 'package:riverpod_annotation/riverpod_annotation.dart';


import '../../../core/database/database.dart';
import '../../../core/repositories/repositories.dart';
import '../../core/models/medication.dart';

part 'providers.g.dart';

// Database provider
@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) => AppDatabase();

// Repository providers
@riverpod
MedicationRepository medicationRepository(MedicationRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return MedicationRepositoryImpl(database);
}

@riverpod
ScheduleRepository scheduleRepository(ScheduleRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return ScheduleRepositoryImpl(database);
}

@riverpod
IntakeRecordRepository intakeRecordRepository(IntakeRecordRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return IntakeRecordRepositoryImpl(database);
}

// Data providers
@riverpod
Future<List<Medication>> medications(MedicationsRef ref) async {
  final repository = ref.watch(medicationRepositoryProvider);
  return repository.getAllMedications();
}

@riverpod
Future<List<MedicationScheduleDto>> activeSchedules(ActiveSchedulesRef ref) async {
  final repository = ref.watch(scheduleRepositoryProvider);
  return repository.getAllActiveSchedules();
}

@riverpod
Future<List<IntakeRecord>> intakeRecordsForDate(
  IntakeRecordsForDateRef ref,
  DateTime date,
) async {
  final repository = ref.watch(intakeRecordRepositoryProvider);
  return repository.getRecordsForDate(date);
}

@riverpod
Future<List<IntakeRecord>> intakeRecordsForDateRange(
  IntakeRecordsForDateRangeRef ref,
  DateTime startDate,
  DateTime endDate,
) async {
  final repository = ref.watch(intakeRecordRepositoryProvider);
  return repository.getRecordsByDateRange(startDate, endDate);
}

// Calendar state provider
@riverpod
class CalendarState extends _$CalendarState {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void goToPreviousWeek() {
    state = state.subtract(const Duration(days: 7));
  }

  void goToNextWeek() {
    state = state.add(const Duration(days: 7));
  }

  void goToToday() {
    state = DateTime.now();
  }

  void goToDate(DateTime date) {
    state = date;
  }
}

// Medication form state provider
@riverpod
class MedicationFormState extends _$MedicationFormState {
  @override
  MedicationFormData build() => const MedicationFormData();

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateDosage(String dosage) {
    state = state.copyWith(dosage: dosage);
  }

  void updateDescription(String? description) {
    state = state.copyWith(description: description);
  }

  void updateIcon(String? icon) {
    state = state.copyWith(icon: icon);
  }

  void addTimeSlot(TimeSlotDto timeSlotDto) {
    state = state.copyWith(
      timeSlots: [...state.timeSlots, timeSlotDto],
    );
  }

  void removeTimeSlot(int index) {
    final newTimeSlots = List<TimeSlotDto>.from(state.timeSlots)
    ..removeAt(index);
    state = state.copyWith(timeSlots: newTimeSlots);
  }

  void updateTimeSlot(int index, TimeSlotDto timeSlotDto) {
    final newTimeSlots = List<TimeSlotDto>.from(state.timeSlots);
    newTimeSlots[index] = timeSlotDto;
    state = state.copyWith(timeSlots: newTimeSlots);
  }

  void setStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
  }

  void setEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
  }

  void reset() {
    state = const MedicationFormData();
  }
}

// Data classes for form state
class MedicationFormData {

  const MedicationFormData({
    this.name = '',
    this.dosage = '',
    this.description,
    this.icon,
    this.timeSlots = const [],
    this.startDate,
    this.endDate,
  });
  final String name;
  final String dosage;
  final String? description;
  final String? icon;
  final List<TimeSlotDto> timeSlots;
  final DateTime? startDate;
  final DateTime? endDate;

  MedicationFormData copyWith({
    String? name,
    String? dosage,
    String? description,
    String? icon,
    List<TimeSlotDto>? timeSlots,
    DateTime? startDate,
    DateTime? endDate,
  }) => MedicationFormData(
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      timeSlots: timeSlots ?? this.timeSlots,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );

  bool get isValid => name.isNotEmpty &&
        dosage.isNotEmpty &&
        timeSlots.isNotEmpty &&
        startDate != null &&
        endDate != null;
}
