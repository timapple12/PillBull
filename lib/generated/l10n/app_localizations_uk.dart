// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'PillBull';

  @override
  String get medicationTracking => 'Відстеження прийому медикаментів';

  @override
  String get calendar => 'Календар';

  @override
  String get medications => 'Ліки';

  @override
  String get statistics => 'Статистика';

  @override
  String get settings => 'Налаштування';

  @override
  String get today => 'Сьогодні';

  @override
  String get tomorrow => 'Завтра';

  @override
  String get yesterday => 'Вчора';

  @override
  String get week => 'Тиждень';

  @override
  String get month => 'Місяць';

  @override
  String get noMedications => 'Немає медикаментів';

  @override
  String get addMedicationToStart => 'Додайте медикаменти для початку трекінгу';

  @override
  String get addMedication => 'Додати медикамент';

  @override
  String get editMedication => 'Редагувати медикамент';

  @override
  String get deleteMedication => 'Видалити медикамент';

  @override
  String confirmDeleteMedication(String name) {
    return 'Ви впевнені, що хочете видалити \"$name\"?';
  }

  @override
  String get cancel => 'Скасувати';

  @override
  String get save => 'Зберегти';

  @override
  String get delete => 'Видалити';

  @override
  String get edit => 'Редагувати';

  @override
  String get add => 'Додати';

  @override
  String get update => 'Оновити';

  @override
  String get medicationName => 'Назва медикаменту';

  @override
  String get dosage => 'Дозування';

  @override
  String get description => 'Опис';

  @override
  String get optional => 'Необов\'язково';

  @override
  String get icon => 'Іконка';

  @override
  String get schedule => 'Розклад';

  @override
  String get startDate => 'Дата початку';

  @override
  String get endDate => 'Дата закінчення';

  @override
  String get selectDate => 'Оберіть дату';

  @override
  String get intakeTime => 'Час прийому';

  @override
  String get addTime => 'Додати час';

  @override
  String get selectTime => 'Оберіть час';

  @override
  String get basicInfo => 'Основна інформація';

  @override
  String get intakeSchedule => 'Розклад прийому';

  @override
  String get addTimeSlot => 'Додайте час прийому ліків';

  @override
  String get scheduled => 'Заплановано';

  @override
  String get taken => 'Прийнято';

  @override
  String get missed => 'Пропущено';

  @override
  String get skipped => 'Відкладено';

  @override
  String get intakeConfirmation => 'Підтвердження прийому';

  @override
  String get scheduledTime => 'Запланований час';

  @override
  String get selectAction => 'Оберіть дію';

  @override
  String get markAsTaken => 'Прийнято';

  @override
  String get skipIntake => 'Пропустити';

  @override
  String get postponeIntake => 'Відкласти прийом';

  @override
  String get skipReason => 'Причина пропуску';

  @override
  String get forgot => 'Забув';

  @override
  String get noMedication => 'Немає ліків';

  @override
  String get feelingUnwell => 'Погане самопочуття';

  @override
  String get otherReason => 'Інша причина';

  @override
  String get postponeIntakeTitle => 'Відкласти прийом';

  @override
  String get selectNewTime => 'Оберіть новий час:';

  @override
  String get confirm => 'Підтвердити';

  @override
  String get medicationMarkedAsTaken => 'Ліки відмічено як прийняті';

  @override
  String get intakeSkipped => 'Прийом ліків пропущено';

  @override
  String get intakePostponed => 'Прийом відкладено';

  @override
  String get selectStartAndEndDates => 'Оберіть дати початку та закінчення';

  @override
  String get addAtLeastOneIntakeTime => 'Додайте принаймні один час прийому';

  @override
  String get enterMedicationName => 'Введіть назву медикаменту';

  @override
  String get enterDosage => 'Введіть дозування';

  @override
  String get overallAdherence => 'Загальне дотримання';

  @override
  String get thisWeek => 'Цього тижня';

  @override
  String get weeklyProgress => 'Прогрес за тижнями';

  @override
  String get adherenceByDays => 'Дотримання по днях';

  @override
  String get detailedStatistics => 'Детальна статистика';

  @override
  String get statusDistribution => 'Розподіл статусів';

  @override
  String get noDataForStatistics => 'Немає даних для статистики';

  @override
  String get addMedicationsAndStartTaking =>
      'Додайте медикаменти та почніть приймати ліки для отримання статистики';

  @override
  String get notifications => 'Сповіщення';

  @override
  String get enableNotifications => 'Увімкнені сповіщення';

  @override
  String get receiveReminders => 'Отримувати нагадування про прийом ліків';

  @override
  String get reminderBefore => 'Нагадування за';

  @override
  String minutesBeforeIntake(int minutes) {
    return '$minutes хвилин до прийому';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes хв';
  }

  @override
  String get quietHours => 'Тихий час';

  @override
  String get doNotDisturbAtNight => 'Не турбувати вночі';

  @override
  String get quietHoursStart => 'Початок тихого часу';

  @override
  String get quietHoursEnd => 'Кінець тихого часу';

  @override
  String get testNotification => 'Тестова нотифікація';

  @override
  String get test => 'Тест';

  @override
  String get notificationsWorkingCorrectly => 'Нотифікації працюють правильно!';

  @override
  String get testNotificationSent => 'Тестова нотифікація відправлена';

  @override
  String get showScheduled => 'Показати заплановані';

  @override
  String get checkLogsInConsole => 'Перевір логи в консолі';

  @override
  String get appearance => 'Зовнішній вигляд';

  @override
  String get darkTheme => 'Темна тема';

  @override
  String get useDarkTheme => 'Використовувати темну тему';

  @override
  String get data => 'Дані';

  @override
  String get exportData => 'Експорт даних';

  @override
  String get saveDataToFile => 'Зберегти дані в файл';

  @override
  String get importData => 'Імпорт даних';

  @override
  String get loadDataFromFile => 'Завантажити дані з файлу';

  @override
  String get backup => 'Резервне копіювання';

  @override
  String get createBackup => 'Створити резервну копію';

  @override
  String get clearData => 'Очистити дані';

  @override
  String get deleteAllData => 'Видалити всі дані';

  @override
  String get aboutApp => 'Про додаток';

  @override
  String get version => 'Версія';

  @override
  String get privacyPolicy => 'Політика конфіденційності';

  @override
  String get readPrivacyPolicy => 'Ознайомитися з політикою';

  @override
  String get termsOfService => 'Умови використання';

  @override
  String get readTermsOfService => 'Ознайомитися з умовами';

  @override
  String get feedback => 'Зворотний зв\'язок';

  @override
  String get contactDevelopers => 'Написати розробникам';

  @override
  String get clearDataConfirmation =>
      'Ви впевнені, що хочете видалити всі дані? Цю дію неможливо скасувати.';

  @override
  String get dataCleared => 'Дані очищено';

  @override
  String get exportFunctionWillBeImplemented =>
      'Функція експорту буде реалізована';

  @override
  String get importFunctionWillBeImplemented =>
      'Функція імпорту буде реалізована';

  @override
  String get backupFunctionWillBeImplemented =>
      'Функція резервного копіювання буде реалізована';

  @override
  String get privacyPolicyWillBeAdded =>
      'Політика конфіденційності буде додана';

  @override
  String get termsOfServiceWillBeAdded => 'Умови використання будуть додані';

  @override
  String get feedbackFunctionWillBeImplemented =>
      'Функція зворотного зв\'язку буде реалізована';

  @override
  String get language => 'Мова';

  @override
  String get selectLanguage => 'Оберіть мову';

  @override
  String get english => 'English';

  @override
  String get ukrainian => 'Українська';

  @override
  String get active => 'Активний';

  @override
  String get createdOn => 'Створено';

  @override
  String get adherence => 'Дотримання';

  @override
  String get adherencePercentage => 'Дотримання (%)';

  @override
  String get monday => 'Пн';

  @override
  String get tuesday => 'Вт';

  @override
  String get wednesday => 'Ср';

  @override
  String get thursday => 'Чт';

  @override
  String get friday => 'Пт';

  @override
  String get saturday => 'Сб';

  @override
  String get sunday => 'Нд';

  @override
  String get january => 'Січень';

  @override
  String get february => 'Лютий';

  @override
  String get march => 'Березень';

  @override
  String get april => 'Квітень';

  @override
  String get may => 'Травень';

  @override
  String get june => 'Червень';

  @override
  String get july => 'Липень';

  @override
  String get august => 'Серпень';

  @override
  String get september => 'Вересень';

  @override
  String get october => 'Жовтень';

  @override
  String get november => 'Листопад';

  @override
  String get december => 'Грудень';

  @override
  String get timeToTakeMedication => 'Час прийняти ліки';

  @override
  String medicationReminderBody(String medicationName, int pillsCount) {
    return '$medicationName - $pillsCount таблеток';
  }

  @override
  String get followUpReminder => 'Нагадування про ліки';

  @override
  String dontForgetToTake(String medicationName) {
    return 'Не забудьте прийняти $medicationName';
  }

  @override
  String get medicationReminders => 'Нагадування про ліки';

  @override
  String get medicationRemindersDescription => 'Нагадування про прийом ліків';

  @override
  String get medicationAdded => 'Медикамент успішно додано';

  @override
  String get medicationUpdated => 'Медикамент успішно оновлено';

  @override
  String get medicationDeleted => 'Медикамент видалено';

  @override
  String get dataExported => 'Дані успішно експортовано';

  @override
  String get dataImported => 'Дані успішно імпортовано';

  @override
  String get importDataWarning => 'Це замінить всі існуючі дані. Ви впевнені?';

  @override
  String get import => 'Імпортувати';

  @override
  String get error => 'Помилка';

  @override
  String get contactUs => 'Зв\'яжіться з нами';

  @override
  String get cannotOpenUrl => 'Не вдається відкрити URL';

  @override
  String get cannotOpenEmail => 'Не вдається відкрити email клієнт';

  @override
  String get cannotOpenTelegram => 'Не вдається відкрити Telegram';

  @override
  String get confirmIntake => 'Підтвердження прийому';

  @override
  String get chooseAction => 'Оберіть дію:';

  @override
  String get skipReasonForgot => 'Забув';

  @override
  String get skipReasonNoMedicine => 'Немає ліків';

  @override
  String get skipReasonFeelBad => 'Погане самопочуття';

  @override
  String get skipReasonOther => 'Інша причина';

  @override
  String get overallStatistics => 'Загальна статистика';

  @override
  String get basicInformation => 'Основна інформація';

  @override
  String get dosageHint => 'Наприклад: 1 таблетка, 5мл';

  @override
  String get descriptionOptional => 'Опис (необов\'язково)';

  @override
  String get additionalNotes => 'Додаткові нотатки';

  @override
  String get addIntakeTime => 'Додайте час прийому ліків';

  @override
  String get selectStartEndDates => 'Оберіть дати початку та закінчення';

  @override
  String get addAtLeastOneTime => 'Додайте принаймні один час прийому';

  @override
  String get created => 'Створено';

  @override
  String get reset => 'Скинути';

  @override
  String get resetIntake => 'Скинути прийом';

  @override
  String get confirmResetIntake => 'Ви впевнені, що хочете скинути цей прийом?';

  @override
  String get unlimited => 'Необмежено';

  @override
  String get oneWeek => '1 Тиждень';

  @override
  String get twoWeeks => '2 Тижні';

  @override
  String get oneMonth => '1 Місяць';

  @override
  String get frequency => 'Періодичність';

  @override
  String get daily => 'Щодня';

  @override
  String get weekly => 'Щотижня';

  @override
  String get monthly => 'Щомісяця';

  @override
  String everyNDays(int n) {
    return 'Кожні $n днів';
  }

  @override
  String get previousMonth => 'Попередній місяць';

  @override
  String get nextMonth => 'Наступний місяць';

  @override
  String get noScheduleForMedication =>
      'Не знайдено розклад для цього медикаменту';

  @override
  String get medicationSkipped => 'Медикамент пропущено';
}
