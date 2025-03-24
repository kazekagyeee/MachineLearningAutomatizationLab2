pipeline {
    agent any

    environment {
        PYTHON_VERSION = '3.12'
        VENV_PATH = 'venv'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Клонирование репозитория...'
                git branch: 'master', url: 'https://github.com/kazekagyeee/MachineLearningAutomatizationLab2'
            }
        }

        stage('Install Python') {
            steps {
                script {
                    if (sh(script: 'command -v python3.12', returnStatus: true) != 0) {
                        echo "Python ${PYTHON_VERSION} не найден. Установка..."
                        sh '''
                            apt update
                            apt install -y make build-essential libssl-dev zlib1g-dev \
                                libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
                                libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev

                            # Установка pyenv
                            curl https://pyenv.run | bash

                            # Добавление pyenv в PATH
                            export PATH="$HOME/.pyenv/bin:$PATH"
                            eval "$(pyenv init --path)"
                            eval "$(pyenv virtualenv-init -)"

                            # Установка Python 3.12
                            pyenv install 3.12.0
                            pyenv global 3.12.0
                        '''
                    } else {
                        echo "Python ${PYTHON_VERSION} уже установлен."
                    }
                }
            }
        }

        stage('Setup Virtual Environment') {
            steps {
                echo 'Создание виртуального окружения...'
                sh '''
                    python3 -m venv ${VENV_PATH}
                    . ${VENV_PATH}/bin/activate
                    pip install --upgrade pip
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Установка зависимостей...'
                sh '''
                    . ${VENV_PATH}/bin/activate
                    if [ -f "requirements.txt" ]; then
                        pip install -r requirements.txt
                    else
                        echo "Файл requirements.txt не найден."
                    fi
                '''
            }
        }

        stage('Run Scripts') {
            steps {
                echo 'Выполнение скриптов...'
                sh '''
                    . ${VENV_PATH}/bin/activate
                    if [ -f "data_creation.py" ]; then
                        python data_creation.py
                    else
                        echo "Файл data_creation.py не найден."
                        exit 1
                    fi

                    if [ -f "model_preprocessing.py" ]; then
                        python model_preprocessing.py
                    else
                        echo "Файл model_preprocessing.py не найден."
                        exit 1
                    fi

                    if [ -f "model_preparation.py" ]; then
                        python model_preparation.py
                    else
                        echo "Файл model_preparation.py не найден."
                        exit 1
                    fi

                    if [ -f "model_testing.py" ]; then
                        python model_testing.py
                    else
                        echo "Файл model_testing.py не найден."
                        exit 1
                    fi
                '''
            }
        }
    }

    post {
        success {
            echo 'Все этапы выполнены успешно.'
        }
        failure {
            echo 'Произошла ошибка при выполнении пайплайна.'
        }
    }
}