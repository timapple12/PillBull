#!/bin/bash

# Скрипт для перевірки консистентності ARB файлів локалізації
# Перевіряє чи всі мови мають однакові ключі

set -e

echo "🔍 Перевірка консистентності ARB файлів..."
echo ""

BASE_FILE="lib/l10n/app_en.arb"

if [ ! -f "$BASE_FILE" ]; then
    echo "❌ Помилка: Базовий файл $BASE_FILE не знайдено"
    exit 1
fi

echo "📋 Базовий файл: $BASE_FILE"
echo ""

# Отримання ключів з базового файлу
BASE_KEYS=$(grep -o '^"[^"]*"' "$BASE_FILE" | sort | uniq)
BASE_COUNT=$(echo "$BASE_KEYS" | wc -l)

echo "📊 Знайдено $BASE_COUNT ключів в базовому файлі"
echo ""

ERRORS=0

# Перевірка кожного ARB файлу
for file in lib/l10n/app_*.arb; do
    if [ "$file" != "$BASE_FILE" ]; then
        echo "🔍 Перевірка $file..."
        
        FILE_KEYS=$(grep -o '^"[^"]*"' "$file" | sort | uniq)
        FILE_COUNT=$(echo "$FILE_KEYS" | wc -l)
        
        # Знаходження відмінностей
        MISSING_KEYS=$(comm -23 <(echo "$BASE_KEYS") <(echo "$FILE_KEYS"))
        EXTRA_KEYS=$(comm -13 <(echo "$BASE_KEYS") <(echo "$FILE_KEYS"))
        
        if [ -n "$MISSING_KEYS" ] || [ -n "$EXTRA_KEYS" ]; then
            echo "❌ Знайдено проблеми в $file"
            ERRORS=$((ERRORS + 1))
            
            if [ -n "$MISSING_KEYS" ]; then
                echo "   🔴 Відсутні ключі ($(echo "$MISSING_KEYS" | wc -l)):"
                echo "$MISSING_KEYS" | sed 's/^/      /'
            fi
            
            if [ -n "$EXTRA_KEYS" ]; then
                echo "   🟡 Зайві ключі ($(echo "$EXTRA_KEYS" | wc -l)):"
                echo "$EXTRA_KEYS" | sed 's/^/      /'
            fi
        else
            echo "✅ Всі ключі співпадають ($FILE_COUNT ключів)"
        fi
        
        echo ""
    fi
done

# Підсумок
if [ $ERRORS -eq 0 ]; then
    echo "🎉 Всі ARB файли консистентні!"
else
    echo "❌ Знайдено $ERRORS файлів з проблемами"
    echo ""
    echo "💡 Для виправлення:"
    echo "   1. Додайте відсутні ключі з базового файлу"
    echo "   2. Видаліть зайві ключі"
    echo "   3. Перекладіть значення на відповідну мову"
    exit 1
fi
