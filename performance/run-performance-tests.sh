#!/bin/bash

# Crear directorio para reportes
mkdir -p performance-reports

# Instalar dependencias
pip install locust

# Ejecutar pruebas de carga ligera
echo "Ejecutando prueba de carga ligera..."
locust -f ecommerce_load_test.py \
    --headless \
    -u 100 \
    -r 10 \
    --run-time 5m \
    --host http://api-gateway:8080 \
    --html performance-reports/light_load_test.html

# Ejecutar pruebas de carga normal
echo "Ejecutando prueba de carga normal..."
locust -f ecommerce_load_test.py \
    --headless \
    -u 200 \
    -r 20 \
    --run-time 10m \
    --host http://api-gateway:8080 \
    --html performance-reports/normal_load_test.html

# Ejecutar pruebas de carga pesada
echo "Ejecutando prueba de carga pesada..."
locust -f ecommerce_load_test.py \
    --headless \
    -u 400 \
    -r 40 \
    --run-time 15m \
    --host http://api-gateway:8080 \
    --html performance-reports/heavy_load_test.html

# Ejecutar prueba de picos
echo "Ejecutando prueba de picos..."
locust -f ecommerce_load_test.py \
    --headless \
    -u 1000 \
    -r 100 \
    --run-time 5m \
    --host http://api-gateway:8080 \
    --html performance-reports/spike_test.html

echo "Pruebas de rendimiento completadas. Reportes disponibles en performance-reports/" 