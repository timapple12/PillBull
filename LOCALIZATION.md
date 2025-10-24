# PillBull Localization System

## Overview

PillBull uses Flutter Intl for localization with support for English and Ukrainian languages. The system is designed for easy addition of new languages.

## Localization Structure

```
lib/
├── l10n/                    # Localization files
│   ├── app_en.arb          # English (base language)
│   └── app_uk.arb          # Ukrainian
├── generated/l10n/         # Generated files
│   └── app_localizations.dart
└── shared/providers/
    └── locale_provider.dart # Localization provider
```

## Adding a New Language

### Step 1: Create ARB File

Create a new file `app_[language_code].arb` in the `lib/l10n/` directory.

For example, for German:
```bash
touch lib/l10n/app_de.arb
```

### Step 2: Copy Base File

Copy the content of `app_en.arb` to the new file and replace the values with the corresponding language:

```json
{
  "@@locale": "de",
  "appTitle": "PillBull",
  "medicationTracking": "Medikamentenverfolgung",
  "calendar": "Kalender",
  "medications": "Medikamente",
  "statistics": "Statistiken",
  "settings": "Einstellungen",
  // ... other translations
}
```

### Step 3: Add Language to Provider

Update the file `lib/shared/providers/locale_provider.dart`:

```dart
final supportedLanguagesProvider = Provider<List<SupportedLanguage>>((ref) {
  return const [
    SupportedLanguage(
      code: 'en',
      name: 'English',
      nativeName: 'English',
    ),
    SupportedLanguage(
      code: 'uk',
      name: 'Ukrainian',
      nativeName: 'Українська',
    ),
    SupportedLanguage(
      code: 'de',
      name: 'German',
      nativeName: 'Deutsch',
    ),
  ];
});
```

### Step 4: Add Locale to MaterialApp

Update the file `lib/main.dart`:

```dart
supportedLocales: const [
  Locale('en', ''), // English
  Locale('uk', ''), // Ukrainian
  Locale('de', ''), // German
],
```

### Step 5: Generate Code

Run code generation:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## ARB File Structure

### Base Keys

Each ARB file should contain:

- `@@locale` - language code
- All keys from the base file `app_en.arb`

### Parameters

For strings with parameters, use placeholders:

```json
{
  "confirmDeleteMedication": "Are you sure you want to delete \"{medicationName}\"?",
  "@confirmDeleteMedication": {
    "description": "Confirmation message for deleting medication",
    "placeholders": {
      "medicationName": {
        "type": "String",
        "description": "Name of the medication to delete"
      }
    }
  }
}
```

### Plural Forms

For plural form support, use ICU syntax:

```json
{
  "itemsCount": "{count, plural, =0{No items} =1{One item} other{{count} items}}",
  "@itemsCount": {
    "description": "Number of items",
    "placeholders": {
      "count": {
        "type": "int",
        "description": "Number of items"
      }
    }
  }
}
```

## Using Localization

### In Widgets

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Text(l10n.appTitle);
  }
}
```

### With Parameters

```dart
Text(l10n.confirmDeleteMedication(medicationName));
```

### In Utilities

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppUtils {
  static String formatDate(DateTime date, AppLocalizations l10n) {
    // Using localized strings
    if (AppUtils.isToday(date)) {
      return l10n.today;
    }
    // ...
  }
}
```

## Best Practices

### 1. Consistency

- Use the same keys in all languages
- Follow the same ARB file structure

### 2. Descriptive Key Names

```json
{
  "medicationName": "Medication Name",  // ✅ Good
  "name": "Name"                        // ❌ Bad
}
```

### 3. Comments and Descriptions

Always add descriptions for complex strings:

```json
{
  "complexMessage": "Complex message with {parameter}",
  "@complexMessage": {
    "description": "Description of what this message is for",
    "placeholders": {
      "parameter": {
        "type": "String",
        "description": "What this parameter represents"
      }
    }
  }
}
```

### 4. Testing

Check translations for:
- Grammar correctness
- Context appropriateness
- Text length (may affect UI)

## Automation

### Script for Adding New Language

Create a script `scripts/add_language.sh`:

```bash
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: ./add_language.sh <language_code> <language_name> <native_name>"
    echo "Example: ./add_language.sh de German Deutsch"
    exit 1
fi

LANG_CODE=$1
LANG_NAME=$2
NATIVE_NAME=$3

# Create ARB file
cp lib/l10n/app_en.arb lib/l10n/app_${LANG_CODE}.arb

# Replace locale
sed -i "s/\"@@locale\": \"en\"/\"@@locale\": \"${LANG_CODE}\"/" lib/l10n/app_${LANG_CODE}.arb

echo "Created lib/l10n/app_${LANG_CODE}.arb"
echo "Don't forget to:"
echo "1. Translate the content"
echo "2. Add language to locale_provider.dart"
echo "3. Add locale to main.dart"
echo "4. Run: flutter packages pub run build_runner build"
```

### Makefile Commands

Add to `Makefile`:

```makefile
.PHONY: generate-l10n add-language

generate-l10n:
	flutter packages pub run build_runner build --delete-conflicting-outputs

add-language:
	@echo "Usage: make add-language LANG_CODE=de LANG_NAME=German NATIVE_NAME=Deutsch"
	@if [ -z "$(LANG_CODE)" ] || [ -z "$(LANG_NAME)" ] || [ -z "$(NATIVE_NAME)" ]; then \
		echo "Error: Please provide LANG_CODE, LANG_NAME, and NATIVE_NAME"; \
		exit 1; \
	fi
	cp lib/l10n/app_en.arb lib/l10n/app_$(LANG_CODE).arb
	sed -i "s/\"@@locale\": \"en\"/\"@@locale\": \"$(LANG_CODE)\"/" lib/l10n/app_$(LANG_CODE).arb
	@echo "Created lib/l10n/app_$(LANG_CODE).arb"
	@echo "Don't forget to translate the content and update providers!"
```

## Localization Validation

### ARB File Linting

Create a script to check consistency:

```bash
#!/bin/bash

echo "Checking ARB file consistency..."

BASE_FILE="lib/l10n/app_en.arb"
BASE_KEYS=$(grep -o '^"[^"]*"' "$BASE_FILE" | sort)

for file in lib/l10n/app_*.arb; do
    if [ "$file" != "$BASE_FILE" ]; then
        echo "Checking $file..."
        FILE_KEYS=$(grep -o '^"[^"]*"' "$file" | sort)
        
        if [ "$BASE_KEYS" != "$FILE_KEYS" ]; then
            echo "❌ Keys mismatch in $file"
            echo "Missing keys:"
            comm -23 <(echo "$BASE_KEYS") <(echo "$FILE_KEYS")
            echo "Extra keys:"
            comm -13 <(echo "$BASE_KEYS") <(echo "$FILE_KEYS")
        else
            echo "✅ Keys match in $file"
        fi
    fi
done
```

## Supported Languages

| Code | Name | Native Name | Status |
|------|------|-------------|--------|
| en  | English | English | ✅ Full support |
| uk  | Ukrainian | Українська | ✅ Full support |
| de  | German | Deutsch | ✅ Full support |
| fr  | French | Français | 📋 Planned |
| es  | Spanish | Español | 📋 Planned |

## Contributing

To add a new language:

1. Create an issue requesting language addition
2. Add ARB file with translations
3. Update providers and configuration
4. Create pull request

## Support

If you have questions about localization, please create an issue or contact the developers.
