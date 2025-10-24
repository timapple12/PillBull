// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PillBull';

  @override
  String get medicationTracking => 'Medication Tracking';

  @override
  String get calendar => 'Calendar';

  @override
  String get medications => 'Medications';

  @override
  String get statistics => 'Statistics';

  @override
  String get settings => 'Settings';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String get noMedications => 'No Medications';

  @override
  String get addMedicationToStart => 'Add medications to start tracking';

  @override
  String get addMedication => 'Add Medication';

  @override
  String get editMedication => 'Edit Medication';

  @override
  String get deleteMedication => 'Delete Medication';

  @override
  String confirmDeleteMedication(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get update => 'Update';

  @override
  String get medicationName => 'Medication Name';

  @override
  String get dosage => 'Dosage';

  @override
  String get description => 'Description';

  @override
  String get optional => 'Optional';

  @override
  String get icon => 'Icon';

  @override
  String get schedule => 'Schedule';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get selectDate => 'Select date';

  @override
  String get intakeTime => 'Intake Time';

  @override
  String get addTime => 'Add time';

  @override
  String get selectTime => 'Select time';

  @override
  String get basicInfo => 'Basic Information';

  @override
  String get intakeSchedule => 'Intake Schedule';

  @override
  String get addTimeSlot => 'Add intake time';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get taken => 'Taken';

  @override
  String get missed => 'Missed';

  @override
  String get skipped => 'Skipped';

  @override
  String get intakeConfirmation => 'Intake Confirmation';

  @override
  String get scheduledTime => 'Scheduled Time';

  @override
  String get selectAction => 'Select Action';

  @override
  String get markAsTaken => 'Mark as Taken';

  @override
  String get skipIntake => 'Skip Intake';

  @override
  String get postponeIntake => 'Postpone Intake';

  @override
  String get skipReason => 'Skip Reason';

  @override
  String get forgot => 'Forgot';

  @override
  String get noMedication => 'No medication';

  @override
  String get feelingUnwell => 'Feeling unwell';

  @override
  String get otherReason => 'Other reason';

  @override
  String get postponeIntakeTitle => 'Postpone Intake';

  @override
  String get selectNewTime => 'Select new time:';

  @override
  String get confirm => 'Confirm';

  @override
  String get medicationMarkedAsTaken => 'Medication marked as taken';

  @override
  String get intakeSkipped => 'Intake skipped';

  @override
  String get intakePostponed => 'Intake postponed';

  @override
  String get selectStartAndEndDates => 'Select start and end dates';

  @override
  String get addAtLeastOneIntakeTime => 'Add at least one intake time';

  @override
  String get enterMedicationName => 'Enter medication name';

  @override
  String get enterDosage => 'Enter dosage';

  @override
  String get overallAdherence => 'Overall Adherence';

  @override
  String get thisWeek => 'This Week';

  @override
  String get weeklyProgress => 'Weekly Progress';

  @override
  String get adherenceByDays => 'Adherence by Days';

  @override
  String get detailedStatistics => 'Detailed Statistics';

  @override
  String get statusDistribution => 'Status Distribution';

  @override
  String get noDataForStatistics => 'No data for statistics';

  @override
  String get addMedicationsAndStartTaking =>
      'Add medications and start taking them to get statistics';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get receiveReminders => 'Receive medication intake reminders';

  @override
  String get reminderBefore => 'Reminder Before';

  @override
  String minutesBeforeIntake(int minutes) {
    return '$minutes minutes before intake';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get quietHours => 'Quiet Hours';

  @override
  String get doNotDisturbAtNight => 'Do not disturb at night';

  @override
  String get quietHoursStart => 'Quiet Hours Start';

  @override
  String get quietHoursEnd => 'Quiet Hours End';

  @override
  String get testNotification => 'Test Notification';

  @override
  String get test => 'Test';

  @override
  String get notificationsWorkingCorrectly =>
      'Notifications are working correctly!';

  @override
  String get testNotificationSent => 'Test notification sent';

  @override
  String get showScheduled => 'Show Scheduled';

  @override
  String get checkLogsInConsole => 'Check logs in console';

  @override
  String get rescheduleAll => 'Reschedule All Notifications';

  @override
  String get notificationsRescheduled => 'All notifications rescheduled';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get useDarkTheme => 'Use dark theme';

  @override
  String get data => 'Data';

  @override
  String get exportData => 'Export Data';

  @override
  String get saveDataToFile => 'Save data to file';

  @override
  String get importData => 'Import Data';

  @override
  String get loadDataFromFile => 'Load data from file';

  @override
  String get backup => 'Backup';

  @override
  String get createBackup => 'Create backup';

  @override
  String get clearData => 'Clear Data';

  @override
  String get deleteAllData => 'Delete all data';

  @override
  String get aboutApp => 'About App';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get readPrivacyPolicy => 'Read privacy policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get readTermsOfService => 'Read terms of service';

  @override
  String get feedback => 'Feedback';

  @override
  String get contactDevelopers => 'Contact developers';

  @override
  String get clearDataConfirmation =>
      'Are you sure you want to delete all data? This action cannot be undone.';

  @override
  String get dataCleared => 'Data cleared';

  @override
  String get exportFunctionWillBeImplemented =>
      'Export function will be implemented';

  @override
  String get importFunctionWillBeImplemented =>
      'Import function will be implemented';

  @override
  String get backupFunctionWillBeImplemented =>
      'Backup function will be implemented';

  @override
  String get privacyPolicyWillBeAdded => 'Privacy policy will be added';

  @override
  String get termsOfServiceWillBeAdded => 'Terms of service will be added';

  @override
  String get feedbackFunctionWillBeImplemented =>
      'Feedback function will be implemented';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get ukrainian => 'Українська';

  @override
  String get active => 'Active';

  @override
  String get createdOn => 'Created on';

  @override
  String get adherence => 'Adherence';

  @override
  String get adherencePercentage => 'Adherence (%)';

  @override
  String get monday => 'Mon';

  @override
  String get tuesday => 'Tue';

  @override
  String get wednesday => 'Wed';

  @override
  String get thursday => 'Thu';

  @override
  String get friday => 'Fri';

  @override
  String get saturday => 'Sat';

  @override
  String get sunday => 'Sun';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get timeToTakeMedication => 'Time to take medication';

  @override
  String medicationReminderBody(String medicationName, int pillsCount) {
    return '$medicationName - $pillsCount pills';
  }

  @override
  String get followUpReminder => 'Medication Reminder';

  @override
  String dontForgetToTake(String medicationName) {
    return 'Don\'t forget to take $medicationName';
  }

  @override
  String get medicationReminders => 'Medication Reminders';

  @override
  String get medicationRemindersDescription =>
      'Reminders for medication intake';

  @override
  String get medicationAdded => 'Medication added successfully';

  @override
  String get medicationUpdated => 'Medication updated successfully';

  @override
  String get medicationDeleted => 'Medication deleted';

  @override
  String get dataExported => 'Data exported successfully';

  @override
  String get dataImported => 'Data imported successfully';

  @override
  String get importDataWarning =>
      'This will replace all existing data. Are you sure?';

  @override
  String get import => 'Import';

  @override
  String get error => 'Error';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get cannotOpenUrl => 'Cannot open URL';

  @override
  String get cannotOpenEmail => 'Cannot open email client';

  @override
  String get cannotOpenTelegram => 'Cannot open Telegram';

  @override
  String get confirmIntake => 'Confirm Intake';

  @override
  String get chooseAction => 'Choose action:';

  @override
  String get skipReasonForgot => 'Forgot';

  @override
  String get skipReasonNoMedicine => 'Out of medicine';

  @override
  String get skipReasonFeelBad => 'Feeling unwell';

  @override
  String get skipReasonOther => 'Other reason';

  @override
  String get overallStatistics => 'Overall Statistics';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get dosageHint => 'e.g.: 1 tablet, 5ml';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get additionalNotes => 'Additional notes';

  @override
  String get addIntakeTime => 'Add medication intake time';

  @override
  String get selectStartEndDates => 'Select start and end dates';

  @override
  String get addAtLeastOneTime => 'Add at least one intake time';

  @override
  String get created => 'Created';

  @override
  String get reset => 'Reset';

  @override
  String get resetIntake => 'Reset Intake';

  @override
  String get confirmResetIntake =>
      'Are you sure you want to reset this intake?';

  @override
  String get unlimited => 'Unlimited';

  @override
  String get oneWeek => '1 Week';

  @override
  String get twoWeeks => '2 Weeks';

  @override
  String get oneMonth => '1 Month';

  @override
  String get frequency => 'Frequency';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String everyNDays(int n) {
    return 'Every $n days';
  }

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get noScheduleForMedication => 'No schedule found for this medication';

  @override
  String get medicationSkipped => 'Medication skipped';

  @override
  String get intakeMissed => 'Intake missed';
}
