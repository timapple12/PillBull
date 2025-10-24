#!/bin/bash

# Скрипт для додавання нової мови в PillBull
# Використання: ./add_language.sh <код_мови> <назва_англійською> <рідна_назва>
# Приклад: ./add_language.sh de German Deutsch

set -e

if [ $# -ne 3 ]; then
    echo "❌ Помилка: Неправильна кількість аргументів"
    echo ""
    echo "Використання: $0 <код_мови> <назва_англійською> <рідна_назва>"
    echo ""
    echo "Приклади:"
    echo "  $0 de German Deutsch"
    echo "  $0 fr French Français"
    echo "  $0 es Spanish Español"
    echo ""
    exit 1
fi

LANG_CODE=$1
LANG_NAME=$2
NATIVE_NAME=$3

echo "🌍 Додавання мови: $LANG_NAME ($NATIVE_NAME) з кодом '$LANG_CODE'"
echo ""

# Перевірка чи існує базовий файл
BASE_FILE="lib/l10n/app_en.arb"
if [ ! -f "$BASE_FILE" ]; then
    echo "❌ Помилка: Базовий файл $BASE_FILE не знайдено"
    exit 1
fi

# Перевірка чи мова вже існує
NEW_FILE="lib/l10n/app_${LANG_CODE}.arb"
if [ -f "$NEW_FILE" ]; then
    echo "⚠️  Попередження: Файл $NEW_FILE вже існує"
    read -p "Перезаписати? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Скасовано"
        exit 1
    fi
fi

echo "📝 Створення ARB файлу..."
cp "$BASE_FILE" "$NEW_FILE"

# Заміна locale
sed -i "s/\"@@locale\": \"en\"/\"@@locale\": \"${LANG_CODE}\"/" "$NEW_FILE"

echo "✅ Створено $NEW_FILE"
echo ""

echo "📋 Наступні кроки:"
echo ""
echo "1. Перекладіть вміст файлу $NEW_FILE"
echo "2. Додайте мову в lib/shared/providers/locale_provider.dart:"
echo ""
echo "   SupportedLanguage("
echo "     code: '$LANG_CODE',"
echo "     name: '$LANG_NAME',"
echo "     nativeName: '$NATIVE_NAME',"
echo "   ),"
echo ""
echo "3. Додайте локалі в lib/main.dart:"
echo ""
echo "   Locale('$LANG_CODE', ''), // $LANG_NAME"
echo ""
echo "4. Запустіть генерацію коду:"
echo ""
echo "   flutter packages pub run build_runner build --delete-conflicting-outputs"
echo ""
echo "5. Перевірте роботу додатку:"
echo ""
echo "   flutter run"
echo ""

echo "🎉 Мова '$LANG_NAME' готова до налаштування!"
