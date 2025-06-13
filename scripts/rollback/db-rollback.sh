#!/bin/bash

# Script de Rollback para Base de Datos
# Uso: ./db-rollback.sh <version_anterior> <backup_file>

set -e

# Variables
VERSION_ANTERIOR=$1
BACKUP_FILE=$2
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="rollback_db_${TIMESTAMP}.log"

# Configuración de base de datos
DB_HOST=${DB_HOST:-"localhost"}
DB_PORT=${DB_PORT:-"5432"}
DB_NAME=${DB_NAME:-"ecommerce"}
DB_USER=${DB_USER:-"postgres"}
DB_PASSWORD=${DB_PASSWORD:-"postgres"}

# Función para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Verificar parámetros
if [ -z "$VERSION_ANTERIOR" ] || [ -z "$BACKUP_FILE" ]; then
    log "Error: Faltan parámetros"
    log "Uso: ./db-rollback.sh <version_anterior> <backup_file>"
    exit 1
fi

# Verificar existencia del archivo de backup
if [ ! -f "$BACKUP_FILE" ]; then
    log "Error: Archivo de backup no encontrado: $BACKUP_FILE"
    exit 1
fi

# Iniciar proceso de rollback
log "Iniciando rollback a versión $VERSION_ANTERIOR"
log "Archivo de backup: $BACKUP_FILE"

# 1. Verificar conexión a la base de datos
log "Verificando conexión a la base de datos..."
if ! PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT 1" > /dev/null 2>&1; then
    log "Error: No se pudo conectar a la base de datos"
    exit 1
fi

# 2. Crear backup de la base actual
log "Creando backup de la base actual..."
CURRENT_BACKUP="db_backup_before_rollback_${TIMESTAMP}.sql"
PGPASSWORD=$DB_PASSWORD pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME > "$CURRENT_BACKUP"
if [ $? -ne 0 ]; then
    log "Error: Fallo al crear backup de la base actual"
    exit 1
fi

# 3. Restaurar backup
log "Restaurando backup..."
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f "$BACKUP_FILE"
if [ $? -ne 0 ]; then
    log "Error: Fallo al restaurar backup"
    log "Intentando restaurar backup actual..."
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f "$CURRENT_BACKUP"
    exit 1
fi

# 4. Verificar integridad
log "Verificando integridad de la base de datos..."
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
    SELECT COUNT(*) FROM pg_tables WHERE schemaname = 'public';
    SELECT COUNT(*) FROM pg_views WHERE schemaname = 'public';
    SELECT COUNT(*) FROM pg_indexes WHERE schemaname = 'public';
" | tee -a "$LOG_FILE"

# 5. Verificar datos críticos
log "Verificando datos críticos..."
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
    -- Verificar tablas críticas
    SELECT COUNT(*) FROM users;
    SELECT COUNT(*) FROM orders;
    SELECT COUNT(*) FROM products;
    SELECT COUNT(*) FROM payments;
" | tee -a "$LOG_FILE"

# Finalizar proceso
log "Rollback completado exitosamente"
log "Verificar logs en: $LOG_FILE"

exit 0 