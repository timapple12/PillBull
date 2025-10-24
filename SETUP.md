# PillBull - Setup Instructions

## Prerequisites

1. **Flutter SDK** (version 3.0.0 or newer)
   ```bash
   flutter --version
   ```

2. **Dart SDK** (included with Flutter)

3. **Android Studio** or **VS Code** with Flutter extensions

4. **Git**

## Installation and Setup

### 1. Clone the project
```bash
git clone <repository-url>
cd pillbull
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Generate code
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 4. Run on Android
```bash
flutter run
```

### 5. Run on iOS (macOS only)
```bash
cd ios
pod install
cd ..
flutter run
```

## Project Structure

```
lib/
├── core/                    # Core components
│   ├── constants/           # Constants and styles
│   ├── database/           # Drift database
│   ├── models/             # Data models
│   ├── repositories/       # Repositories
│   └── services/           # Services
├── features/               # Feature modules
│   ├── calendar/           # Calendar screen
│   ├── medications/        # Medication management
│   ├── statistics/        # Statistics
│   ├── settings/           # Settings
│   └── main/               # Main screen
└── shared/                 # Shared components
    ├── providers/          # Riverpod providers
    └── widgets/            # Shared widgets
```

## Main Features

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

## Development

### Code Generation
```bash
# Generate Drift code
flutter packages pub run build_runner build

# Generate Riverpod code
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Testing
```bash
flutter test
```

### Linting
```bash
flutter analyze
```

### Build APK
```bash
flutter build apk --release
```

### Build for iOS
```bash
flutter build ios --release
```

## Configuration

### Android
- Minimum version: API 21 (Android 5.0)
- Permissions: INTERNET, RECEIVE_BOOT_COMPLETED, VIBRATE, WAKE_LOCK, POST_NOTIFICATIONS

### iOS
- Minimum version: iOS 11.0
- Permissions: Notifications

## Known Issues

1. **Code Generation**: If you encounter code generation errors, try:
   ```bash
   flutter clean
   flutter pub get
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

2. **Android Notifications**: Make sure the app has notification permissions

3. **Database**: A local SQLite database is created on first run

## Support

If you have questions or issues, please create an issue in the repository or contact the developers.
