# Guía de Uso de Scripts de Rollback

## Requisitos Previos

### Software Necesario
- Git
- Maven
- Docker
- kubectl (para Kubernetes)
- Acceso a bases de datos
- Permisos de ejecución en scripts

### Configuración
1. Dar permisos de ejecución a los scripts:
   ```bash
   chmod +x scripts/rollback/*.sh
   ```

2. Configurar variables de entorno:
   ```bash
   export DB_HOST=localhost
   export DB_PORT=5432
   export DB_USER=usuario
   export DB_PASSWORD=contraseña
   ```

## Uso de Scripts

### 1. Rollback de Base de Datos
```bash
./scripts/rollback/db-rollback.sh <version_anterior> <archivo_backup>
```
Ejemplo:
```bash
./scripts/rollback/db-rollback.sh v1.0.0 /backups/db_backup_20240311.sql
```

### 2. Rollback de Configuraciones
```bash
./scripts/rollback/config-rollback.sh <version_anterior> <directorio_config>
```
Ejemplo:
```bash
./scripts/rollback/config-rollback.sh v1.0.0 /config/backup/v1.0.0
```

### 3. Rollback de Código
```bash
./scripts/rollback/code-rollback.sh <version_anterior> <servicio>
```
Ejemplo:
```bash
./scripts/rollback/code-rollback.sh v1.0.0 user-service
```

## Orden de Ejecución

1. **Preparación**
   - Verificar estado actual
   - Crear backups
   - Notificar stakeholders

2. **Ejecución**
   - Rollback de código
   - Rollback de configuraciones
   - Rollback de base de datos

3. **Verificación**
   - Comprobar estado de servicios
   - Verificar integridad de datos
   - Validar funcionalidad

## Troubleshooting

### Problemas Comunes

1. **Error de Permisos**
   ```bash
   chmod +x scripts/rollback/*.sh
   ```

2. **Error de Conexión a Base de Datos**
   - Verificar variables de entorno
   - Comprobar firewall
   - Validar credenciales

3. **Error en Rollback de Código**
   - Verificar estado de Git
   - Comprobar ramas
   - Validar tags

### Logs
- Los logs se guardan en el directorio actual
- Formato: `rollback_<tipo>_<timestamp>.log`

## Mejores Prácticas

1. **Antes de Ejecutar**
   - Crear backup completo
   - Notificar al equipo
   - Verificar recursos

2. **Durante la Ejecución**
   - Monitorear logs
   - Verificar cada paso
   - Documentar acciones

3. **Después de Ejecutar**
   - Validar sistema
   - Actualizar documentación
   - Notificar resultado 