# Script para generar Release Notes
param(
    [Parameter(Mandatory=$true)]
    [string]$Version,
    
    [Parameter(Mandatory=$true)]
    [string]$PreviousTag
)

# Función para logging
function Write-Log {
    param($Message)
    Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
}

# Crear archivo de release notes
$releaseNotesFile = "release_notes_${Version}.md"
Write-Log "Generando release notes para versión $Version..."

# Encabezado
@"
# Release Notes $Version

## Resumen de Cambios
"@ | Out-File -FilePath $releaseNotesFile -Encoding UTF8

# Obtener commits desde el tag anterior
Write-Log "Obteniendo commits desde $PreviousTag..."
$commits = git log --pretty=format:"%s" "$PreviousTag..HEAD"
if (-not ($commits -is [System.Array])) { $commits = @($commits) }

foreach ($commit in $commits) {
    if ($commit -match "^feat:") {
        "- [NUEVA CARACTERISTICA] $($commit -replace '^feat: ', '')" | Out-File -FilePath $releaseNotesFile -Append -Encoding UTF8
    }
    elseif ($commit -match "^fix:") {
        "- [CORRECCION] $($commit -replace '^fix: ', '')" | Out-File -FilePath $releaseNotesFile -Append -Encoding UTF8
    }
    elseif ($commit -match "^docs:") {
        "- [DOCUMENTACION] $($commit -replace '^docs: ', '')" | Out-File -FilePath $releaseNotesFile -Append -Encoding UTF8
    }
    elseif ($commit -match "^refactor:") {
        "- [REFACTORIZACION] $($commit -replace '^refactor: ', '')" | Out-File -FilePath $releaseNotesFile -Append -Encoding UTF8
    }
    elseif ($commit -match "^test:") {
        "- [TESTS] $($commit -replace '^test: ', '')" | Out-File -FilePath $releaseNotesFile -Append -Encoding UTF8
    }
    elseif ($commit -match "^chore:") {
        "- [MANTENIMIENTO] $($commit -replace '^chore: ', '')" | Out-File -FilePath $releaseNotesFile -Append -Encoding UTF8
    }
}

# Agregar sección de breaking changes
@"

## Breaking Changes
"@ | Out-File -FilePath $releaseNotesFile -Append -Encoding UTF8

$breakingChanges = git log --pretty=format:"%s" "$PreviousTag..HEAD" | Select-String -Pattern "breaking change"
if ($breakingChanges) {
    foreach ($change in $breakingChanges) {
        "- $($change.Line)" | Out-File -FilePath $releaseNotesFile -Append -Encoding UTF8
    }
}
else {
    "[No hay breaking changes]" | Out-File -FilePath $releaseNotesFile -Append -Encoding UTF8
}

# Agregar sección de dependencias actualizadas
@"

## Dependencias Actualizadas
"@ | Out-File -FilePath $releaseNotesFile -Append -Encoding UTF8

$dependencies = git log --pretty=format:"%s" "$PreviousTag..HEAD" | Select-String -Pattern "update dependency"
if ($dependencies) {
    foreach ($dep in $dependencies) {
        "- $($dep.Line)" | Out-File -FilePath $releaseNotesFile -Append -Encoding UTF8
    }
}
else {
    "[No hay dependencias actualizadas]" | Out-File -FilePath $releaseNotesFile -Append -Encoding UTF8
}

# Agregar sección de notas de instalación
@"

## Notas de Instalacion
1. Actualizar a la ultima version: `git checkout $Version`
2. Ejecutar `./mvnw clean install`
3. Desplegar usando los scripts de despliegue

## Plan de Rollback
En caso de problemas, ejecutar:
```
./scripts/rollback/code-rollback.sh $PreviousTag <servicio>
./scripts/rollback/config-rollback.sh $PreviousTag <config_dir>
./scripts/rollback/db-rollback.sh $PreviousTag <backup_file>
```
"@ | Out-File -FilePath $releaseNotesFile -Append -Encoding UTF8

Write-Log "Release notes generados en $releaseNotesFile" 