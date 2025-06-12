#!/bin/bash

# Script de Rollback para Código
# Uso: ./code-rollback.sh <version_anterior> <servicio>

set -e

# Variables
VERSION_ANTERIOR=$1
SERVICIO=$2
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="rollback_code_${TIMESTAMP}.log"

# Configuración
MAVEN_OPTS="-DskipTests=true"
KUBE_NAMESPACE="ecommerce"

# Función para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Verificar parámetros
if [ -z "$VERSION_ANTERIOR" ] || [ -z "$SERVICIO" ]; then
    log "Error: Faltan parámetros"
    log "Uso: ./code-rollback.sh <version_anterior> <servicio>"
    exit 1
fi

# Iniciar proceso de rollback
log "Iniciando rollback de código para $SERVICIO a versión $VERSION_ANTERIOR"

# 1. Verificar estado actual del repositorio
log "Verificando estado del repositorio..."
if ! git status --porcelain | grep -q '^'; then
    log "Error: Hay cambios sin commitear en el repositorio"
    exit 1
fi

# 2. Crear rama de rollback
BRANCH_NAME="rollback_${SERVICIO}_${VERSION_ANTERIOR}_${TIMESTAMP}"
log "Creando rama de rollback: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"

# 3. Revertir a la versión anterior
log "Revertiendo a versión $VERSION_ANTERIOR..."
git checkout "$VERSION_ANTERIOR"

# 4. Verificar cambios
log "Verificando cambios..."
git diff --name-status HEAD@{1} HEAD

# 5. Compilar y verificar
log "Compilando código..."
cd "$SERVICIO"
./mvnw clean package $MAVEN_OPTS
if [ $? -ne 0 ]; then
    log "Error: Fallo en la compilación"
    exit 1
fi

# 6. Ejecutar tests
log "Ejecutando tests..."
./mvnw test
if [ $? -ne 0 ]; then
    log "Error: Fallos en los tests"
    exit 1
fi

# 7. Desplegar
log "Desplegando versión anterior..."

# Construir imagen Docker
log "Construyendo imagen Docker..."
docker build -t "$SERVICIO:$VERSION_ANTERIOR" .

# Desplegar en Kubernetes
log "Desplegando en Kubernetes..."
kubectl set image deployment/$SERVICIO $SERVICIO=$SERVICIO:$VERSION_ANTERIOR -n $KUBE_NAMESPACE

# Esperar a que el despliegue esté completo
log "Esperando a que el despliegue esté completo..."
kubectl rollout status deployment/$SERVICIO -n $KUBE_NAMESPACE

# Verificar estado del servicio
log "Verificando estado del servicio..."
kubectl get pods -n $KUBE_NAMESPACE -l app=$SERVICIO

# Finalizar proceso
log "Rollback de código completado exitosamente"
log "Verificar logs en: $LOG_FILE"

exit 0 