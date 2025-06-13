# Script de prueba para el proceso de release
# Uso: .\test-release-process.ps1

# Función para logging
function Write-Log {
    param($Message)
    Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
}

# 1. Verificar estado del repositorio
Write-Log "Verificando estado del repositorio..."
$status = git status --porcelain
if ($status) {
    Write-Log "Error: Hay cambios sin commitear"
    exit 1
}

# 2. Obtener última versión
$lastTag = git describe --tags --abbrev=0
$newVersion = "v0.$(Get-Random -Minimum 1 -Maximum 100).0"

# 3. Crear commit de prueba
Write-Log "Creando commit de prueba..."
git commit --allow-empty -m "feat: característica de prueba" -m "Esta es una característica de prueba para el proceso de release"

# 4. Crear nuevo tag
Write-Log "Creando tag $newVersion..."
git tag -a $newVersion -m "Version de prueba"

# 5. Generar release notes
Write-Log "Generando release notes..."
.\scripts\generate-release-notes.ps1 $newVersion $lastTag

# 6. Verificar archivos generados
Write-Log "Verificando archivos generados..."
if (Test-Path "release_notes_$newVersion.md") {
    Write-Log "Release notes generados correctamente"
} else {
    Write-Log "Error: No se generaron los release notes"
    exit 1
}

# 7. Probar scripts de rollback
Write-Log "Probando scripts de rollback..."
.\scripts\rollback\code-rollback.ps1 $lastTag "user-service"
.\scripts\rollback\config-rollback.ps1 $lastTag ".\config\backup"
.\scripts\rollback\db-rollback.ps1 $lastTag ".\backups\db_backup.sql"

# 8. Limpiar
Write-Log "Limpiando..."
git tag -d $newVersion
git reset --hard HEAD~1

Write-Log "Prueba completada exitosamente" 