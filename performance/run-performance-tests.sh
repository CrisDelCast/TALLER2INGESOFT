#!/usr/bin/env bash
set -e

# Variables parametrizables
HOST=${TARGET_HOST:-http://api-gateway:8080}
USERS=${USERS:-300}
SPAWN_RATE=${SPAWN_RATE:-30}
RUNTIME=${RUNTIME:-10m}
REPORT_DIR=${REPORT_DIR:-performance-reports}

mkdir -p "$REPORT_DIR"

echo "Ejecutando prueba de rendimiento con Locust..."

docker run --rm \
  -v "$(pwd)":/mnt/locust \
  -w /mnt/locust/performance \
  locustio/locust:latest \
  -f ecommerce_load_test.py \
  --headless \
  -u "$USERS" \
  -r "$SPAWN_RATE" \
  --run-time "$RUNTIME" \
  --host "$HOST" \
  --csv "$REPORT_DIR/locust" \
  --html "$REPORT_DIR/locust_report.html"

echo "Pruebas de rendimiento completadas. Reportes en $REPORT_DIR" 