import os
import pandas as pd
from sklearn.metrics import mean_squared_error, r2_score
import joblib

# Функция для загрузки данных из папки
def load_data_from_folder(folder_path):
    data_frames = []
    for file_name in os.listdir(folder_path):
        if file_name.endswith('.csv'):
            file_path = os.path.join(folder_path, file_name)
            df = pd.read_csv(file_path)
            data_frames.append(df)
    return pd.concat(data_frames, ignore_index=True)

# Путь к папке test
test_folder = 'test'

# Загрузка данных из папки test
test_data = load_data_from_folder(test_folder)

# Разделение данных на признаки (X) и целевую переменную (y)
X_test = test_data[['x']]  # Признаки (одна колонка 'x')
y_test = test_data['y']    # Целевая переменная ('y')

# Загрузка предварительно обученной модели
model_path = 'model/linear_regression_model.pkl'
if not os.path.exists(model_path):
    raise FileNotFoundError(f"Модель не найдена по пути: {model_path}")

model = joblib.load(model_path)

# Предсказание на тестовых данных
y_pred = model.predict(X_test)

# Оценка качества модели
mse = mean_squared_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)

print(f"Модель успешно протестирована.")
print(f"Коэффициенты модели: вес = {model.coef_[0]:.2f}, смещение = {model.intercept_:.2f}")
print(f"Среднеквадратичная ошибка (MSE): {mse:.2f}")
print(f"Коэффициент детерминации (R^2): {r2:.2f}")