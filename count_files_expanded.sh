#!/bin/bash

# Розширений скрипт підрахунку файлів
TARGET_DIR="$1"
#Ручне введення бажаного розширення
read -r -p "Enter file extension: " extension

# Перевірка існування директорії
if [ ! -d "$TARGET_DIR" ]; then
    echo "Помилка: директорія $TARGET_DIR не існує"
    exit 1
fi
# Функція для підрахунку
count_items() {
    local dir=$1
    local type=$2
    local ext=$3

    if [[ "$type" == "f" ]]; then
        find "$dir" -type "$type" -name "*.$ext" 2>/dev/null | wc -l
    else
        find "$dir" -type "$type" 2>/dev/null | wc -l

    fi
}
# Підрахунок різних типів
files=$(count_items "$TARGET_DIR" "f" "$extension")
dirs=$(count_items "$TARGET_DIR" "d")
links=$(count_items "$TARGET_DIR" "l")

#Підрахунок загального розміру файлів
total_size=$(find "$TARGET_DIR" -type f -name "*.$extension" -printf '%s\n' |
    awk '{sum += $1} END {print sum+0}')

# Виведення результатів
echo "Статистика директорії $TARGET_DIR:"
echo "  Файли з розширенням .$extension (включно з піддиректоріями): $files"
echo "  Директорії (включно з піддиректоріями): $((dirs - 1))" #Віднімаємо саму директорію
echo "  Символічні посилання (включно з піддиректоріями): $links" 
echo "  -------------------------"
echo "  Разом (тільки файли): $files"
echo "  Загальний розмір файлів: $total_size байт"
