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