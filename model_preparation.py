import os
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score

# Функция для загрузки данных из папки
def load_data_from_folder(folder_path):
    data_frames = []
    for file_name in os.listdir(folder_path):
        if file_name.endswith('.csv'):
            file_path = os.path.join(folder_path, file_name)
            df = pd.read_csv(file_path)
            data_frames.append(df)
    return pd.concat(data_frames, ignore_index=True)

# Путь к папке train
train_folder = 'train'

# Загрузка данных из папки train
train_data = load_data_from_folder(train_folder)

# Разделение данных на признаки (X) и целевую переменную (y)
X_train = train_data[['x']]  # Признаки (одна колонка 'x')
y_train = train_data['y']    # Целевая переменная ('y')

# Создание и обучение модели линейной регрессии
model = LinearRegression()
model.fit(X_train, y_train)

# Предсказание на тренировочных данных
y_pred = model.predict(X_train)

# Оценка качества модели
mse = mean_squared_error(y_train, y_pred)
r2 = r2_score(y_train, y_pred)

print(f"Модель успешно обучена.")
print(f"Коэффициенты модели: вес = {model.coef_[0]:.2f}, смещение = {model.intercept_:.2f}")
print(f"Среднеквадратичная ошибка (MSE): {mse:.2f}")
print(f"Коэффициент детерминации (R^2): {r2:.2f}")

# Сохранение модели (опционально)
import joblib
os.makedirs('model', exist_ok=True)
joblib.dump(model, 'model/linear_regression_model.pkl')

print("Модель сохранена в файл 'model/linear_regression_model.pkl'.")