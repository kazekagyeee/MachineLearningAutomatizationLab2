#!/bin/bash

# 2. Создание и активация виртуального окружения
echo "Создание виртуального окружения..."
python3 -m venv venv
source venv/bin/activate
echo "Виртуальное окружение создано и активировано."

# 3. Установка библиотек из requirements.txt
if [ -f "requirements.txt" ]; then
    echo "Установка библиотек из requirements.txt..."
    pip3 install --upgrade pip
    pip3 install -r requirements.txt --break-system-packages
else
    echo "Файл requirements.txt не найден. Пропуск установки библиотек."
fi

# 4. Запуск data_creation.py
if [ -f "data_creation.py" ]; then
    echo "Запуск data_creation.py..."
    python3 data_creation.py
else
    echo "Файл data_creation.py не найден."
    exit 1
fi

# 5. Запуск model_preprocessing.py
if [ -f "model_preprocessing.py" ]; then
    echo "Запуск model_preprocessing.py..."
    python3 model_preprocessing.py
else
    echo "Файл model_preprocessing.py не найден."
    exit 1
fi

# 6. Запуск model_preparation.py
if [ -f "model_preparation.py" ]; then
    echo "Запуск model_preparation.py..."
    python3 model_preparation.py
else
    echo "Файл model_preparation.py не найден."
    exit 1
fi

# 7. Запуск model_testing.py
if [ -f "model_testing.py" ]; then
    echo "Запуск model_testing.py..."
    python3 model_testing.py
else
    echo "Файл model_testing.py не найден."
    exit 1
fi

echo "Все этапы выполнены успешно."