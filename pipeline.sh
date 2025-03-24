#!/bin/bash

# Проверка, что скрипт выполняется в Linux
if [[ "$(uname)" == "Linux" ]]; then
    # 1. Проверка установки Python 3.12 и установка, если его нет
    echo "Проверка наличия Python 3.12..."
    if command -v python3.12 &>/dev/null; then
        echo "Python 3.12 уже установлен."
    else
        echo "Python 3.12 не найден. Установка Python 3.12..."
        # Для Ubuntu/Debian (может потребоваться sudo)
        sudo apt update
        sudo apt install -y build-essential libssl-dev zlib1g-dev \
            libncurses5-dev libgdbm-dev libnss3-dev libsqlite3-dev \
            libreadline-dev libffi-dev curl libbz2-dev
        curl https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz > Python-3.12.0.tgz
        tar -xf Python-3.12.0.tgz
        cd Python-3.12.0
        ./configure --enable-optimizations
        make -j$(nproc)
        sudo make altinstall
        cd ..
        rm -rf Python-3.12.0 Python-3.12.0.tgz
        echo "Python 3.12 установлен."
    fi
else
    echo "Скрипт выполняется не в Linux. Пропуск установки Python 3.12."
fi

# 2. Создание и активация виртуального окружения
echo "Создание виртуального окружения..."
python3 -m venv venv
source venv/bin/activate
echo "Виртуальное окружение создано и активировано."

# 3. Установка библиотек из requirements.txt
if [ -f "requirements.txt" ]; then
    echo "Установка библиотек из requirements.txt..."
    pip install --upgrade pip
    pip install -r requirements.txt --break-system-packages
else
    echo "Файл requirements.txt не найден. Пропуск установки библиотек."
fi

# 4. Запуск data_creation.py
if [ -f "data_creation.py" ]; then
    echo "Запуск data_creation.py..."
    python data_creation.py
else
    echo "Файл data_creation.py не найден."
    exit 1
fi

# 5. Запуск model_preprocessing.py
if [ -f "model_preprocessing.py" ]; then
    echo "Запуск model_preprocessing.py..."
    python model_preprocessing.py
else
    echo "Файл model_preprocessing.py не найден."
    exit 1
fi

# 6. Запуск model_preparation.py
if [ -f "model_preparation.py" ]; then
    echo "Запуск model_preparation.py..."
    python model_preparation.py
else
    echo "Файл model_preparation.py не найден."
    exit 1
fi

# 7. Запуск model_testing.py
if [ -f "model_testing.py" ]; then
    echo "Запуск model_testing.py..."
    python model_testing.py
else
    echo "Файл model_testing.py не найден."
    exit 1
fi

echo "Все этапы выполнены успешно."