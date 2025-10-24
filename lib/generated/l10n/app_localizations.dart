import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('uk')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'PillBull'**
  String get appTitle;

  /// Subtitle for medication tracking
  ///
  /// In en, this message translates to:
  /// **'Medication Tracking'**
  String get medicationTracking;

  /// Calendar tab label
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// Medications tab title
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medications;

  /// Statistics tab title
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Settings tab title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Today label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Tomorrow label
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// Yesterday label
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Week label
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// Month label
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// Empty state title for medications
  ///
  /// In en, this message translates to:
  /// **'No Medications'**
  String get noMedications;

  /// Message to encourage adding medications
  ///
  /// In en, this message translates to:
  /// **'Add medications to start tracking'**
  String get addMedicationToStart;

  /// Add medication button text
  ///
  /// In en, this message translates to:
  /// **'Add Medication'**
  String get addMedication;

  /// Edit medication dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Medication'**
  String get editMedication;

  /// Title for delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Medication'**
  String get deleteMedication;

  /// Confirmation message for deleting medication
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String confirmDeleteMedication(String name);

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button label
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Add button label
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Update button label
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Medication name field label
  ///
  /// In en, this message translates to:
  /// **'Medication Name'**
  String get medicationName;

  /// Dosage field label
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Optional field indicator
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// Icon selector label
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// Schedule section title
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// Start date field label
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// End date field label
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// Placeholder for date selection
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// Time slots section title
  ///
  /// In en, this message translates to:
  /// **'Intake Time'**
  String get intakeTime;

  /// Add time button label
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get addTime;

  /// Button to select time
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// Basic information section title
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInfo;

  /// Schedule section title
  ///
  /// In en, this message translates to:
  /// **'Intake Schedule'**
  String get intakeSchedule;

  /// Add intake time button text
  ///
  /// In en, this message translates to:
  /// **'Add intake time'**
  String get addTimeSlot;

  /// Scheduled status
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// Taken status
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get taken;

  /// Missed status
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missed;

  /// Skipped status
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get skipped;

  /// Intake confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Intake Confirmation'**
  String get intakeConfirmation;

  /// Scheduled time label
  ///
  /// In en, this message translates to:
  /// **'Scheduled Time'**
  String get scheduledTime;

  /// Select action prompt
  ///
  /// In en, this message translates to:
  /// **'Select Action'**
  String get selectAction;

  /// Mark as taken button text
  ///
  /// In en, this message translates to:
  /// **'Mark as Taken'**
  String get markAsTaken;

  /// Skip intake button text
  ///
  /// In en, this message translates to:
  /// **'Skip Intake'**
  String get skipIntake;

  /// Title for postpone dialog
  ///
  /// In en, this message translates to:
  /// **'Postpone Intake'**
  String get postponeIntake;

  /// Title for skip reason dialog
  ///
  /// In en, this message translates to:
  /// **'Skip Reason'**
  String get skipReason;

  /// Forgot skip reason
  ///
  /// In en, this message translates to:
  /// **'Forgot'**
  String get forgot;

  /// No medication skip reason
  ///
  /// In en, this message translates to:
  /// **'No medication'**
  String get noMedication;

  /// Feeling unwell skip reason
  ///
  /// In en, this message translates to:
  /// **'Feeling unwell'**
  String get feelingUnwell;

  /// Other reason skip reason
  ///
  /// In en, this message translates to:
  /// **'Other reason'**
  String get otherReason;

  /// Postpone intake dialog title
  ///
  /// In en, this message translates to:
  /// **'Postpone Intake'**
  String get postponeIntakeTitle;

  /// Prompt to select new time
  ///
  /// In en, this message translates to:
  /// **'Select new time:'**
  String get selectNewTime;

  /// Confirm button label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Success message for marking medication as taken
  ///
  /// In en, this message translates to:
  /// **'Medication marked as taken'**
  String get medicationMarkedAsTaken;

  /// Success message for skipping intake
  ///
  /// In en, this message translates to:
  /// **'Intake skipped'**
  String get intakeSkipped;

  /// Success message for postponing intake
  ///
  /// In en, this message translates to:
  /// **'Intake postponed'**
  String get intakePostponed;

  /// Error message for missing dates
  ///
  /// In en, this message translates to:
  /// **'Select start and end dates'**
  String get selectStartAndEndDates;

  /// Error message for missing intake times
  ///
  /// In en, this message translates to:
  /// **'Add at least one intake time'**
  String get addAtLeastOneIntakeTime;

  /// Validation message for medication name
  ///
  /// In en, this message translates to:
  /// **'Enter medication name'**
  String get enterMedicationName;

  /// Validation message for dosage
  ///
  /// In en, this message translates to:
  /// **'Enter dosage'**
  String get enterDosage;

  /// Title for overall adherence card
  ///
  /// In en, this message translates to:
  /// **'Overall Adherence'**
  String get overallAdherence;

  /// Title for this week adherence card
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// Title for weekly progress section
  ///
  /// In en, this message translates to:
  /// **'Weekly Progress'**
  String get weeklyProgress;

  /// Adherence by days chart title
  ///
  /// In en, this message translates to:
  /// **'Adherence by Days'**
  String get adherenceByDays;

  /// Title for detailed statistics section
  ///
  /// In en, this message translates to:
  /// **'Detailed Statistics'**
  String get detailedStatistics;

  /// Title for status distribution section
  ///
  /// In en, this message translates to:
  /// **'Status Distribution'**
  String get statusDistribution;

  /// Message when no data available for statistics
  ///
  /// In en, this message translates to:
  /// **'No data for statistics'**
  String get noDataForStatistics;

  /// Message to encourage adding medications for statistics
  ///
  /// In en, this message translates to:
  /// **'Add medications and start taking them to get statistics'**
  String get addMedicationsAndStartTaking;

  /// Notifications section title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Enable notifications setting
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// Receive reminders setting description
  ///
  /// In en, this message translates to:
  /// **'Receive medication intake reminders'**
  String get receiveReminders;

  /// Reminder before setting
  ///
  /// In en, this message translates to:
  /// **'Reminder Before'**
  String get reminderBefore;

  /// Minutes before intake setting
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes before intake'**
  String minutesBeforeIntake(int minutes);

  /// Short format for minutes
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// Quiet hours setting
  ///
  /// In en, this message translates to:
  /// **'Quiet Hours'**
  String get quietHours;

  /// Do not disturb at night setting description
  ///
  /// In en, this message translates to:
  /// **'Do not disturb at night'**
  String get doNotDisturbAtNight;

  /// Quiet hours start setting
  ///
  /// In en, this message translates to:
  /// **'Quiet Hours Start'**
  String get quietHoursStart;

  /// Quiet hours end setting
  ///
  /// In en, this message translates to:
  /// **'Quiet Hours End'**
  String get quietHoursEnd;

  /// Test notification button
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get testNotification;

  /// Test
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get test;

  /// Notifications working message
  ///
  /// In en, this message translates to:
  /// **'Notifications are working correctly!'**
  String get notificationsWorkingCorrectly;

  /// Test notification sent message
  ///
  /// In en, this message translates to:
  /// **'Test notification sent'**
  String get testNotificationSent;

  /// Show scheduled notifications button
  ///
  /// In en, this message translates to:
  /// **'Show Scheduled'**
  String get showScheduled;

  /// Check logs message
  ///
  /// In en, this message translates to:
  /// **'Check logs in console'**
  String get checkLogsInConsole;

  /// Reschedule all notifications button
  ///
  /// In en, this message translates to:
  /// **'Reschedule All Notifications'**
  String get rescheduleAll;

  /// Notifications rescheduled message
  ///
  /// In en, this message translates to:
  /// **'All notifications rescheduled'**
  String get notificationsRescheduled;

  /// Appearance section title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Dark theme setting
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// Use dark theme setting description
  ///
  /// In en, this message translates to:
  /// **'Use dark theme'**
  String get useDarkTheme;

  /// Data section title
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// Export data setting
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// Save data to file setting description
  ///
  /// In en, this message translates to:
  /// **'Save data to file'**
  String get saveDataToFile;

  /// Import data setting
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// Load data from file setting description
  ///
  /// In en, this message translates to:
  /// **'Load data from file'**
  String get loadDataFromFile;

  /// Backup setting
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// Create backup setting description
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get createBackup;

  /// Clear data setting
  ///
  /// In en, this message translates to:
  /// **'Clear Data'**
  String get clearData;

  /// Delete all data setting description
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get deleteAllData;

  /// About app section title
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Privacy policy setting
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Read privacy policy setting description
  ///
  /// In en, this message translates to:
  /// **'Read privacy policy'**
  String get readPrivacyPolicy;

  /// Terms of service setting
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Read terms of service setting description
  ///
  /// In en, this message translates to:
  /// **'Read terms of service'**
  String get readTermsOfService;

  /// Feedback setting
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// Contact developers setting description
  ///
  /// In en, this message translates to:
  /// **'Contact developers'**
  String get contactDevelopers;

  /// Clear data confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all data? This action cannot be undone.'**
  String get clearDataConfirmation;

  /// Data cleared success message
  ///
  /// In en, this message translates to:
  /// **'Data cleared'**
  String get dataCleared;

  /// Export function placeholder message
  ///
  /// In en, this message translates to:
  /// **'Export function will be implemented'**
  String get exportFunctionWillBeImplemented;

  /// Import function placeholder message
  ///
  /// In en, this message translates to:
  /// **'Import function will be implemented'**
  String get importFunctionWillBeImplemented;

  /// Backup function placeholder message
  ///
  /// In en, this message translates to:
  /// **'Backup function will be implemented'**
  String get backupFunctionWillBeImplemented;

  /// Privacy policy placeholder message
  ///
  /// In en, this message translates to:
  /// **'Privacy policy will be added'**
  String get privacyPolicyWillBeAdded;

  /// Terms of service placeholder message
  ///
  /// In en, this message translates to:
  /// **'Terms of service will be added'**
  String get termsOfServiceWillBeAdded;

  /// Feedback function placeholder message
  ///
  /// In en, this message translates to:
  /// **'Feedback function will be implemented'**
  String get feedbackFunctionWillBeImplemented;

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Select language setting description
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Ukrainian language option
  ///
  /// In en, this message translates to:
  /// **'Українська'**
  String get ukrainian;

  /// Active status label
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Created on label
  ///
  /// In en, this message translates to:
  /// **'Created on'**
  String get createdOn;

  /// Adherence label
  ///
  /// In en, this message translates to:
  /// **'Adherence'**
  String get adherence;

  /// Adherence percentage label
  ///
  /// In en, this message translates to:
  /// **'Adherence (%)'**
  String get adherencePercentage;

  /// Monday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// Tuesday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// Wednesday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// Thursday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// Friday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// Saturday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// Sunday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// January month name
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// February month name
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// March month name
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// April month name
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// May month name
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// June month name
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// July month name
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// August month name
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// September month name
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// October month name
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// November month name
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// December month name
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// Medication reminder title
  ///
  /// In en, this message translates to:
  /// **'Time to take medication'**
  String get timeToTakeMedication;

  /// Medication reminder body
  ///
  /// In en, this message translates to:
  /// **'{medicationName} - {pillsCount} pills'**
  String medicationReminderBody(String medicationName, int pillsCount);

  /// Follow-up reminder title
  ///
  /// In en, this message translates to:
  /// **'Medication Reminder'**
  String get followUpReminder;

  /// Follow-up reminder body
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to take {medicationName}'**
  String dontForgetToTake(String medicationName);

  /// Medication reminders channel name
  ///
  /// In en, this message translates to:
  /// **'Medication Reminders'**
  String get medicationReminders;

  /// Medication reminders channel description
  ///
  /// In en, this message translates to:
  /// **'Reminders for medication intake'**
  String get medicationRemindersDescription;

  /// Success message when medication is added
  ///
  /// In en, this message translates to:
  /// **'Medication added successfully'**
  String get medicationAdded;

  /// Success message when medication is updated
  ///
  /// In en, this message translates to:
  /// **'Medication updated successfully'**
  String get medicationUpdated;

  /// Success message when medication is deleted
  ///
  /// In en, this message translates to:
  /// **'Medication deleted'**
  String get medicationDeleted;

  /// Data export success message
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully'**
  String get dataExported;

  /// Data import success message
  ///
  /// In en, this message translates to:
  /// **'Data imported successfully'**
  String get dataImported;

  /// Warning before importing data
  ///
  /// In en, this message translates to:
  /// **'This will replace all existing data. Are you sure?'**
  String get importDataWarning;

  /// Import button label
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// Error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Contact us dialog title
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// Error when URL cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Cannot open URL'**
  String get cannotOpenUrl;

  /// Error when email cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Cannot open email client'**
  String get cannotOpenEmail;

  /// Error when Telegram cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Cannot open Telegram'**
  String get cannotOpenTelegram;

  /// Title for intake confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm Intake'**
  String get confirmIntake;

  /// Prompt to choose an action
  ///
  /// In en, this message translates to:
  /// **'Choose action:'**
  String get chooseAction;

  /// Skip reason: forgot to take medication
  ///
  /// In en, this message translates to:
  /// **'Forgot'**
  String get skipReasonForgot;

  /// Skip reason: no medicine available
  ///
  /// In en, this message translates to:
  /// **'Out of medicine'**
  String get skipReasonNoMedicine;

  /// Skip reason: feeling bad
  ///
  /// In en, this message translates to:
  /// **'Feeling unwell'**
  String get skipReasonFeelBad;

  /// Skip reason: other
  ///
  /// In en, this message translates to:
  /// **'Other reason'**
  String get skipReasonOther;

  /// Title for overall statistics section
  ///
  /// In en, this message translates to:
  /// **'Overall Statistics'**
  String get overallStatistics;

  /// Basic information section title
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// Hint for dosage field
  ///
  /// In en, this message translates to:
  /// **'e.g.: 1 tablet, 5ml'**
  String get dosageHint;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// Hint for description field
  ///
  /// In en, this message translates to:
  /// **'Additional notes'**
  String get additionalNotes;

  /// Empty state message for time slots
  ///
  /// In en, this message translates to:
  /// **'Add medication intake time'**
  String get addIntakeTime;

  /// Validation message for dates
  ///
  /// In en, this message translates to:
  /// **'Select start and end dates'**
  String get selectStartEndDates;

  /// Validation message for time slots
  ///
  /// In en, this message translates to:
  /// **'Add at least one intake time'**
  String get addAtLeastOneTime;

  /// Created label
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// Reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Reset intake button text
  ///
  /// In en, this message translates to:
  /// **'Reset Intake'**
  String get resetIntake;

  /// Confirm reset intake message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset this intake?'**
  String get confirmResetIntake;

  /// Unlimited duration option
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// One week quick filter
  ///
  /// In en, this message translates to:
  /// **'1 Week'**
  String get oneWeek;

  /// Two weeks quick filter
  ///
  /// In en, this message translates to:
  /// **'2 Weeks'**
  String get twoWeeks;

  /// One month quick filter
  ///
  /// In en, this message translates to:
  /// **'1 Month'**
  String get oneMonth;

  /// Medication frequency label
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// Daily frequency
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// Weekly frequency
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// Monthly frequency
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// Every N days frequency
  ///
  /// In en, this message translates to:
  /// **'Every {n} days'**
  String everyNDays(int n);

  /// Previous month tooltip
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// Next month tooltip
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// Error when medication has no schedule
  ///
  /// In en, this message translates to:
  /// **'No schedule found for this medication'**
  String get noScheduleForMedication;

  /// Medication skipped message
  ///
  /// In en, this message translates to:
  /// **'Medication skipped'**
  String get medicationSkipped;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
