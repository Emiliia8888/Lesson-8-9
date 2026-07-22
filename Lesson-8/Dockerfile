# Базовий образ Python
FROM python:3.10-slim

# Встановлюємо системні залежності для PostgreSQL (libpq-dev, gcc)
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Створюємо робочу директорію всередині контейнера
WORKDIR /app

# Копіюємо файл із залежностями та встановлюємо їх
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо весь код нашого Django-додатка в контейнер
COPY . .

# Виставляємо порт, на якому працюватиме Django
EXPOSE 8000

# Правильна команда запуску через manage.py
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
