#!/bin/bash

# Colores para la salida
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Iniciando prueba de pipelines...${NC}\n"

# Función para verificar el estado de un pipeline
check_pipeline() {
    local pipeline=$1
    echo -e "${YELLOW}Probando pipeline: ${pipeline}${NC}"
    
    # Ejecutar el pipeline
    jenkins-cli build ${pipeline} -s
    
    # Verificar el resultado
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Pipeline ${pipeline} completado exitosamente${NC}"
        return 0
    else
        echo -e "${RED}✗ Pipeline ${pipeline} falló${NC}"
        return 1
    fi
}

# Lista de pipelines a probar
pipelines=(
    "main-pipeline"
    "api-gateway-pipeline"
    "cloud-config-pipeline"
    "service-discovery-pipeline"
    "order-service-pipeline"
    "product-service-pipeline"
    "user-service-pipeline"
    "unit-tests-pipeline"
    "integration-tests-pipeline"
    "performance-tests-pipeline"
    "k8s-deployment-pipeline"
)

# Contador de éxitos y fallos
success=0
failed=0

# Probar cada pipeline
for pipeline in "${pipelines[@]}"; do
    if check_pipeline "$pipeline"; then
        ((success++))
    else
        ((failed++))
    fi
    echo "----------------------------------------"
done

# Mostrar resumen
echo -e "\n${YELLOW}Resumen de pruebas:${NC}"
echo -e "${GREEN}Pipelines exitosos: ${success}${NC}"
echo -e "${RED}Pipelines fallidos: ${failed}${NC}"

# Verificar el estado en el dashboard
echo -e "\n${YELLOW}Verificando estado en el dashboard...${NC}"
curl -s http://localhost:8080/view/E-commerce%20Dashboard/api/json | jq '.'

# Salir con código de error si hay fallos
if [ $failed -gt 0 ]; then
    exit 1
fi 