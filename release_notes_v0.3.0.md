# Release Notes v0.3.0

## Resumen de Cambios
- [DOCUMENTACION] actualizar documentaci├│n de API
- [CORRECCION] corregir error en login
- [NUEVA CARACTERISTICA] implementar sistema de usuarios

## Breaking Changes
[No hay breaking changes]

## Dependencias Actualizadas
[No hay dependencias actualizadas]

## Notas de Instalacion
1. Actualizar a la ultima version: git checkout v0.3.0
2. Ejecutar ./mvnw clean install
3. Desplegar usando los scripts de despliegue

## Plan de Rollback
En caso de problemas, ejecutar:
`
./scripts/rollback/code-rollback.sh v0.2.0 <servicio>
./scripts/rollback/config-rollback.sh v0.2.0 <config_dir>
./scripts/rollback/db-rollback.sh v0.2.0 <backup_file>
`
