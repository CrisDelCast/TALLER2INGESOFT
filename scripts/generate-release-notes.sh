#!/bin/bash

# Script para generar Release Notes automáticamente
# Uso: ./generate-release-notes.sh <version> <tag_anterior>

set -e

# Variables
VERSION=$1
TAG_ANTERIOR=$2
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RELEASE_NOTES_FILE="release_notes_${VERSION}.md"

# Función para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Verificar parámetros
if [ -z "$VERSION" ] || [ -z "$TAG_ANTERIOR" ]; then
    log "Error: Faltan parámetros"
    log "Uso: ./generate-release-notes.sh <version> <tag_anterior>"
    exit 1
fi

# Crear archivo de release notes
log "Generando release notes para versión $VERSION..."

# Encabezado
cat > "$RELEASE_NOTES_FILE" << EOF
# Release Notes v$VERSION

## Resumen de Cambios
EOF

# Obtener commits desde el tag anterior
log "Obteniendo commits desde $TAG_ANTERIOR..."
git log --pretty=format:"%s" $TAG_ANTERIOR..HEAD | while read -r commit; do
    # Categorizar commits
    if [[ $commit =~ ^feat: ]]; then
        echo "- 🚀 Nueva característica: ${commit#feat: }" >> "$RELEASE_NOTES_FILE"
    elif [[ $commit =~ ^fix: ]]; then
        echo "- 🐛 Corrección: ${commit#fix: }" >> "$RELEASE_NOTES_FILE"
    elif [[ $commit =~ ^docs: ]]; then
        echo "- 📚 Documentación: ${commit#docs: }" >> "$RELEASE_NOTES_FILE"
    elif [[ $commit =~ ^refactor: ]]; then
        echo "- ♻️ Refactorización: ${commit#refactor: }" >> "$RELEASE_NOTES_FILE"
    elif [[ $commit =~ ^test: ]]; then
        echo "- ✅ Tests: ${commit#test: }" >> "$RELEASE_NOTES_FILE"
    elif [[ $commit =~ ^chore: ]]; then
        echo "- 🔧 Mantenimiento: ${commit#chore: }" >> "$RELEASE_NOTES_FILE"
    fi
done

# Agregar sección de breaking changes
log "Verificando breaking changes..."
echo -e "\n## Breaking Changes" >> "$RELEASE_NOTES_FILE"
git log --pretty=format:"%s" $TAG_ANTERIOR..HEAD | grep -i "breaking change" | while read -r commit; do
    echo "- ${commit}" >> "$RELEASE_NOTES_FILE"
done

# Agregar sección de dependencias actualizadas
log "Verificando dependencias actualizadas..."
echo -e "\n## Dependencias Actualizadas" >> "$RELEASE_NOTES_FILE"
git log --pretty=format:"%s" $TAG_ANTERIOR..HEAD | grep -i "update dependency" | while read -r commit; do
    echo "- ${commit}" >> "$RELEASE_NOTES_FILE"
done

# Agregar sección de notas de instalación
echo -e "\n## Notas de Instalación" >> "$RELEASE_NOTES_FILE"
echo "1. Actualizar a la última versión: \`git checkout v$VERSION\`" >> "$RELEASE_NOTES_FILE"
echo "2. Ejecutar \`./mvnw clean install\`" >> "$RELEASE_NOTES_FILE"
echo "3. Desplegar usando los scripts de despliegue" >> "$RELEASE_NOTES_FILE"

# Agregar sección de rollback
echo -e "\n## Plan de Rollback" >> "$RELEASE_NOTES_FILE"
echo "En caso de problemas, ejecutar:" >> "$RELEASE_NOTES_FILE"
echo "\`\`\`bash" >> "$RELEASE_NOTES_FILE"
echo "./scripts/rollback/code-rollback.sh $TAG_ANTERIOR <servicio>" >> "$RELEASE_NOTES_FILE"
echo "./scripts/rollback/config-rollback.sh $TAG_ANTERIOR <config_dir>" >> "$RELEASE_NOTES_FILE"
echo "./scripts/rollback/db-rollback.sh $TAG_ANTERIOR <backup_file>" >> "$RELEASE_NOTES_FILE"
echo "\`\`\`" >> "$RELEASE_NOTES_FILE"

log "Release notes generados en $RELEASE_NOTES_FILE"
exit 0 