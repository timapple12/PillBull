# PillBull - Medication Tracking App

Flutter app for tracking medication intake with calendar interface and reminder system.

## Features

### 📅 Calendar Interface
- Horizontal grid with 7 days
- Visual indicators for intake status
- Week navigation with swipe gestures
- Tap on cell to confirm intake

### 💊 Medication Management
- Create medications with name, dosage, description
- Flexible intake schedule (daily, weekly, custom)
- Different number of pills for different days
- Set course duration

### 🔔 Notification System
- Local push notifications
- Configure morning/evening intake times
- Mandatory confirmation of intake or skip
- Quiet hours (no disturbance at night)

### 📊 Statistics and Tracking
- Intake history
- Adherence statistics
- Progress visualization by weeks
- Detailed statistics by status

## Tech Stack

- **Flutter** with Dart
- **State Management**: Riverpod
- **Database**: Drift (formerly Moor)
- **Notifications**: flutter_local_notifications + workmanager
- **UI**: Material You design with dark theme support
- **Architecture**: Clean Architecture

## Project Structure

```
lib/
├── core/
│   ├── constants/          # Constants and styles
│   ├── database/          # Drift database
│   ├── models/            # Data models
│   ├── repositories/      # Repositories
│   └── services/          # Services (notifications)
├── features/
│   ├── calendar/          # Calendar screen
│   ├── medications/       # Medication management
│   ├── statistics/        # Statistics
│   ├── settings/          # Settings
│   └── main/              # Main screen
└── shared/
    ├── providers/          # Riverpod providers
    └── widgets/           # Shared widgets
```

## Installation and Setup

### Prerequisites
- Flutter SDK (3.0.0+)
- Dart SDK
- Android Studio / Xcode
- Git

### Quick Start

```bash
# Clone repository
git clone <repository-url>
cd pillbull

# Quick setup
make setup

# Run app
make run
```

### Manual Installation

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd pillbull
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run app**
   ```bash
   flutter run
   ```

### For Android
- Minimum version: API 21 (Android 5.0)
- Permissions: INTERNET, RECEIVE_BOOT_COMPLETED, VIBRATE, WAKE_LOCK, POST_NOTIFICATIONS

### For iOS
- Minimum version: iOS 11.0
- Permissions: Notifications

## Main Features

### Calendar Grid
- Shows 7 days at once
- Horizontal scroll for navigation
- Color coding for statuses:
  - 🔵 Blue - scheduled
  - 🟢 Green - taken
  - 🔴 Red - missed
  - 🟡 Yellow - postponed

### Schedule Creation
- Quick templates: "Daily X times", "Every other day"
- Custom mode with detailed configuration
- Constructor for complex schedules with different patterns

### Reminders
- 15 minutes before intake (configurable)
- Repeat reminder after 30 minutes
- Critical reminder after 1 hour
- Quiet hours from 22:00 to 7:00

## Data Models

### Medication
```dart
class Medication {
  String id;
  String name;
  String dosage;
  String? description;
  String? icon;
  DateTime createdAt;
  DateTime updatedAt;
}
```

### MedicationSchedule
```dart
class MedicationSchedule {
  String id;
  String medicationId;
  DateTime startDate;
  DateTime endDate;
  List<DosagePattern> patterns;
  bool isActive;
  DateTime createdAt;
}
```

### IntakeRecord
```dart
class IntakeRecord {
  String id;
  String medicationId;
  DateTime scheduledTime;
  DateTime? actualTime;
  IntakeStatus status;
  String? skipReason;
  DateTime createdAt;
}
```

## Settings

### Notifications
- Enable/disable reminders
- Configure warning time
- Quiet hours
- Configure quiet hours start/end time

### Appearance
- Dark/light theme
- Automatic switching based on system

### Data
- Export data
- Import data
- Backup
- Clear data

## Localization

PillBull supports multiple languages with easy addition of new ones:

### Supported Languages
- 🇺🇸 **English** (base language)
- 🇺🇦 **Ukrainian** (full support)
- 🇩🇪 **German** (full support)

### Adding New Language

```bash
# Using script
make add-language LANG_CODE=de LANG_NAME=German NATIVE_NAME=Deutsch

# Or manual addition
./scripts/add_language.sh de German Deutsch
```

### Localization Validation

```bash
# Check consistency
make check-l10n

# Generate localization files
make generate-l10n
```

Detailed documentation: [LOCALIZATION.md](LOCALIZATION.md)

## Development

### Main Commands

```bash
# Quick start
make setup

# Run app
make run

# Check code
make check

# Add new language
make add-language LANG_CODE=de LANG_NAME=German NATIVE_NAME=Deutsch
```

### Code Generation
```bash
# Generate Drift code
flutter packages pub run build_runner build --delete-conflicting-outputs

# Or use Makefile
make generate-l10n
```

### Testing
```bash
flutter test
```

### Linting
```bash
flutter analyze
```

## Future Features

- [ ] Export schedule to PDF
- [ ] Cloud backup (Google Drive)
- [ ] Home screen widget
- [ ] Device synchronization
- [ ] Medical system integration
- [ ] Analytics and reports for doctors

## License

MIT License - see LICENSE file for details.

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## Support

If you have questions or issues, please create an issue in the repository or contact the developers.
