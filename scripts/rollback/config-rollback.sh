#!/bin/bash

# Script de Rollback para Configuraciones
# Uso: ./config-rollback.sh <version_anterior> <config_backup_dir>

set -e

# Variables
VERSION_ANTERIOR=$1
CONFIG_BACKUP_DIR=$2
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="rollback_config_${TIMESTAMP}.log"

# Directorios de configuración
CONFIG_DIRS=(
    "cloud-config"
    "service-discovery"
    "api-gateway"
    "user-service"
    "order-service"
    "product-service"
    "payment-service"
    "shipping-service"
    "favourite-service"
)

# Función para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Verificar parámetros
if [ -z "$VERSION_ANTERIOR" ] || [ -z "$CONFIG_BACKUP_DIR" ]; then
    log "Error: Faltan parámetros"
    log "Uso: ./config-rollback.sh <version_anterior> <config_backup_dir>"
    exit 1
fi

# Verificar existencia del directorio de backup
if [ ! -d "$CONFIG_BACKUP_DIR" ]; then
    log "Error: Directorio de backup no encontrado: $CONFIG_BACKUP_DIR"
    exit 1
fi

# Iniciar proceso de rollback
log "Iniciando rollback de configuraciones a versión $VERSION_ANTERIOR"
log "Directorio de backup: $CONFIG_BACKUP_DIR"

# 1. Crear backup de configuraciones actuales
log "Creando backup de configuraciones actuales..."
BACKUP_DIR="config_backup_${TIMESTAMP}"
mkdir -p "$BACKUP_DIR"

for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        cp -r "$dir" "$BACKUP_DIR/"
    fi
done

# 2. Listar archivos de configuración a restaurar
log "Archivos de configuración a restaurar:"
find "$CONFIG_BACKUP_DIR" -type f -name "*.yml" -o -name "*.properties" | while read -r file; do
    log "  - $file"
done

# 3. Restaurar configuraciones
log "Restaurando configuraciones..."
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$CONFIG_BACKUP_DIR/$dir" ]; then
        log "Restaurando configuración para $dir..."
        # Crear directorio si no existe
        mkdir -p "$dir"
        # Copiar archivos de configuración
        cp -r "$CONFIG_BACKUP_DIR/$dir"/* "$dir/"
    fi
done

# 4. Verificar configuraciones
log "Verificando configuraciones restauradas..."
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        log "Verificando $dir..."
        # Verificar archivos YAML
        find "$dir" -name "*.yml" -exec sh -c 'echo "Validando {}"; yamllint {}' \;
        # Verificar archivos properties
        find "$dir" -name "*.properties" -exec sh -c 'echo "Verificando {}"; cat {}' \;
    fi
done

# 5. Reiniciar servicios si es necesario
log "Reiniciando servicios afectados..."
# Reiniciar servicios de configuración
kubectl rollout restart deployment config-server -n ecommerce
kubectl rollout restart deployment service-discovery -n ecommerce

# Esperar a que los servicios estén listos
log "Esperando a que los servicios estén listos..."
kubectl rollout status deployment config-server -n ecommerce
kubectl rollout status deployment service-discovery -n ecommerce

# Finalizar proceso
log "Rollback de configuraciones completado exitosamente"
log "Verificar logs en: $LOG_FILE"

exit 0 