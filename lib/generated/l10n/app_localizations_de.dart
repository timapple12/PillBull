// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'PillBull';

  @override
  String get medicationTracking => 'Medikamentenverfolgung';

  @override
  String get calendar => 'Kalender';

  @override
  String get medications => 'Medikamente';

  @override
  String get statistics => 'Statistiken';

  @override
  String get settings => 'Einstellungen';

  @override
  String get today => 'Heute';

  @override
  String get tomorrow => 'Morgen';

  @override
  String get yesterday => 'Gestern';

  @override
  String get week => 'Woche';

  @override
  String get month => 'Monat';

  @override
  String get noMedications => 'Keine Medikamente';

  @override
  String get addMedicationToStart =>
      'Medikamente hinzufügen, um mit der Verfolgung zu beginnen';

  @override
  String get addMedication => 'Medikament hinzufügen';

  @override
  String get editMedication => 'Medikament bearbeiten';

  @override
  String get deleteMedication => 'Medikament löschen';

  @override
  String confirmDeleteMedication(String name) {
    return 'Möchten Sie \"$name\" wirklich löschen?';
  }

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get add => 'Hinzufügen';

  @override
  String get update => 'Aktualisieren';

  @override
  String get medicationName => 'Medikamentenname';

  @override
  String get dosage => 'Dosierung';

  @override
  String get description => 'Beschreibung';

  @override
  String get optional => 'Optional';

  @override
  String get icon => 'Symbol';

  @override
  String get schedule => 'Zeitplan';

  @override
  String get startDate => 'Startdatum';

  @override
  String get endDate => 'Enddatum';

  @override
  String get selectDate => 'Datum wählen';

  @override
  String get intakeTime => 'Einnahmezeit';

  @override
  String get addTime => 'Zeit hinzufügen';

  @override
  String get selectTime => 'Zeit wählen';

  @override
  String get basicInfo => 'Grundinformationen';

  @override
  String get intakeSchedule => 'Einnahmeplan';

  @override
  String get addTimeSlot => 'Einnahmezeit hinzufügen';

  @override
  String get scheduled => 'Geplant';

  @override
  String get taken => 'Eingenommen';

  @override
  String get missed => 'Verpasst';

  @override
  String get skipped => 'Übersprungen';

  @override
  String get intakeConfirmation => 'Einnahmebestätigung';

  @override
  String get scheduledTime => 'Geplante Zeit';

  @override
  String get selectAction => 'Aktion auswählen';

  @override
  String get markAsTaken => 'Als eingenommen markieren';

  @override
  String get skipIntake => 'Einnahme überspringen';

  @override
  String get postponeIntake => 'Einnahme verschieben';

  @override
  String get skipReason => 'Grund fürs Überspringen';

  @override
  String get forgot => 'Vergessen';

  @override
  String get noMedication => 'Kein Medikament';

  @override
  String get feelingUnwell => 'Sich unwohl fühlen';

  @override
  String get otherReason => 'Anderer Grund';

  @override
  String get postponeIntakeTitle => 'Einnahme verschieben';

  @override
  String get selectNewTime => 'Neue Zeit wählen:';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get medicationMarkedAsTaken => 'Medikament als eingenommen markiert';

  @override
  String get intakeSkipped => 'Einnahme übersprungen';

  @override
  String get intakePostponed => 'Einnahme verschoben';

  @override
  String get selectStartAndEndDates => 'Start- und Enddatum auswählen';

  @override
  String get addAtLeastOneIntakeTime =>
      'Mindestens eine Einnahmezeit hinzufügen';

  @override
  String get enterMedicationName => 'Medikamentenname eingeben';

  @override
  String get enterDosage => 'Dosierung eingeben';

  @override
  String get overallAdherence => 'Gesamte Einhaltung';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get weeklyProgress => 'Wöchentlicher Fortschritt';

  @override
  String get adherenceByDays => 'Einhaltung nach Tagen';

  @override
  String get detailedStatistics => 'Detaillierte Statistik';

  @override
  String get statusDistribution => 'Statusverteilung';

  @override
  String get noDataForStatistics => 'Keine Daten für Statistiken';

  @override
  String get addMedicationsAndStartTaking =>
      'Medikamente hinzufügen und mit der Einnahme beginnen, um Statistiken zu erhalten';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get enableNotifications => 'Benachrichtigungen aktivieren';

  @override
  String get receiveReminders =>
      'Erinnerungen für Medikamenteneinnahme erhalten';

  @override
  String get reminderBefore => 'Erinnerung vor';

  @override
  String minutesBeforeIntake(int minutes) {
    return '$minutes Minuten vor der Einnahme';
  }

  @override
  String get quietHours => 'Ruhezeiten';

  @override
  String get doNotDisturbAtNight => 'Nachts nicht stören';

  @override
  String get quietHoursStart => 'Ruhezeiten Beginn';

  @override
  String get quietHoursEnd => 'Ruhezeiten Ende';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get darkTheme => 'Dunkles Design';

  @override
  String get useDarkTheme => 'Dunkles Design verwenden';

  @override
  String get data => 'Daten';

  @override
  String get exportData => 'Daten exportieren';

  @override
  String get saveDataToFile => 'Daten in Datei speichern';

  @override
  String get importData => 'Daten importieren';

  @override
  String get loadDataFromFile => 'Daten aus Datei laden';

  @override
  String get backup => 'Backup';

  @override
  String get createBackup => 'Backup erstellen';

  @override
  String get clearData => 'Daten löschen';

  @override
  String get deleteAllData => 'Alle Daten löschen';

  @override
  String get aboutApp => 'Über die App';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get readPrivacyPolicy => 'Datenschutzrichtlinie lesen';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get readTermsOfService => 'Nutzungsbedingungen lesen';

  @override
  String get feedback => 'Feedback';

  @override
  String get contactDevelopers => 'Entwickler kontaktieren';

  @override
  String get clearDataConfirmation =>
      'Sind Sie sicher, dass Sie alle Daten löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get dataCleared => 'Daten gelöscht';

  @override
  String get exportFunctionWillBeImplemented =>
      'Export-Funktion wird implementiert';

  @override
  String get importFunctionWillBeImplemented =>
      'Import-Funktion wird implementiert';

  @override
  String get backupFunctionWillBeImplemented =>
      'Backup-Funktion wird implementiert';

  @override
  String get privacyPolicyWillBeAdded =>
      'Datenschutzrichtlinie wird hinzugefügt';

  @override
  String get termsOfServiceWillBeAdded =>
      'Nutzungsbedingungen werden hinzugefügt';

  @override
  String get feedbackFunctionWillBeImplemented =>
      'Feedback-Funktion wird implementiert';

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get english => 'English';

  @override
  String get ukrainian => 'Українська';

  @override
  String get active => 'Aktiv';

  @override
  String get createdOn => 'Erstellt am';

  @override
  String get adherence => 'Einhaltung';

  @override
  String get adherencePercentage => 'Einhaltung (%)';

  @override
  String get monday => 'Mo';

  @override
  String get tuesday => 'Di';

  @override
  String get wednesday => 'Mi';

  @override
  String get thursday => 'Do';

  @override
  String get friday => 'Fr';

  @override
  String get saturday => 'Sa';

  @override
  String get sunday => 'So';

  @override
  String get january => 'Januar';

  @override
  String get february => 'Februar';

  @override
  String get march => 'März';

  @override
  String get april => 'April';

  @override
  String get may => 'Mai';

  @override
  String get june => 'Juni';

  @override
  String get july => 'Juli';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'Oktober';

  @override
  String get november => 'November';

  @override
  String get december => 'Dezember';

  @override
  String get timeToTakeMedication => 'Zeit, Medikament einzunehmen';

  @override
  String medicationReminderBody(String medicationName, int pillsCount) {
    return '$medicationName - $pillsCount Tabletten';
  }

  @override
  String get followUpReminder => 'Medikamentenerinnerung';

  @override
  String dontForgetToTake(String medicationName) {
    return 'Vergessen Sie nicht, $medicationName einzunehmen';
  }

  @override
  String get medicationReminders => 'Medikamentenerinnerungen';

  @override
  String get medicationRemindersDescription =>
      'Erinnerungen für Medikamenteneinnahme';

  @override
  String get medicationAdded => 'Medikament erfolgreich hinzugefügt';

  @override
  String get medicationUpdated => 'Medikament erfolgreich aktualisiert';

  @override
  String get medicationDeleted => 'Medikament gelöscht';

  @override
  String get dataExported => 'Daten erfolgreich exportiert';

  @override
  String get dataImported => 'Daten erfolgreich importiert';

  @override
  String get importDataWarning =>
      'Dies ersetzt alle vorhandenen Daten. Sind Sie sicher?';

  @override
  String get import => 'Importieren';

  @override
  String get error => 'Fehler';

  @override
  String get contactUs => 'Kontaktieren Sie uns';

  @override
  String get cannotOpenUrl => 'URL kann nicht geöffnet werden';

  @override
  String get cannotOpenEmail => 'E-Mail-Client kann nicht geöffnet werden';

  @override
  String get cannotOpenTelegram => 'Telegram kann nicht geöffnet werden';

  @override
  String get confirmIntake => 'Einnahme bestätigen';

  @override
  String get chooseAction => 'Aktion wählen:';

  @override
  String get skipReasonForgot => 'Vergessen';

  @override
  String get skipReasonNoMedicine => 'Keine Medizin';

  @override
  String get skipReasonFeelBad => 'Fühle mich schlecht';

  @override
  String get skipReasonOther => 'Anderer Grund';

  @override
  String get overallStatistics => 'Gesamtstatistik';

  @override
  String get basicInformation => 'Grundinformationen';

  @override
  String get dosageHint => 'z.B.: 1 Tablette, 5ml';

  @override
  String get descriptionOptional => 'Beschreibung (optional)';

  @override
  String get additionalNotes => 'Zusätzliche Notizen';

  @override
  String get addIntakeTime => 'Medikamenteneinnahmezeit hinzufügen';

  @override
  String get selectStartEndDates => 'Start- und Enddatum wählen';

  @override
  String get addAtLeastOneTime => 'Mindestens eine Einnahmezeit hinzufügen';

  @override
  String get created => 'Erstellt';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get resetIntake => 'Einnahme zurücksetzen';

  @override
  String get confirmResetIntake =>
      'Möchten Sie diese Einnahme wirklich zurücksetzen?';

  @override
  String get unlimited => 'Unbegrenzt';

  @override
  String get oneWeek => '1 Woche';

  @override
  String get twoWeeks => '2 Wochen';

  @override
  String get oneMonth => '1 Monat';

  @override
  String get frequency => 'Häufigkeit';

  @override
  String get daily => 'Täglich';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get monthly => 'Monatlich';

  @override
  String everyNDays(int n) {
    return 'Alle $n Tage';
  }
}
