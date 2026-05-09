FROM python:3.11-slim

# Install system dependencies for psycopg2 and Pillow
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    libjpeg-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

# Copy all project files
COPY . .

# Expose port and run Gunicorn
WORKDIR /app/DaM/backend
CMD sh -c 'python -c "from database import init_db; init_db()" && gunicorn -w 4 -b 0.0.0.0:${PORT:-5000} "app:create_app()"'
