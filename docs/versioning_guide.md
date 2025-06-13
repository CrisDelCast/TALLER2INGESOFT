# Guía de Versionado

## Convención de Versionado

Utilizamos [Versionado Semántico](https://semver.org/) (MAJOR.MINOR.PATCH):

- **MAJOR**: Cambios incompatibles con versiones anteriores
- **MINOR**: Nuevas funcionalidades compatibles con versiones anteriores
- **PATCH**: Correcciones de errores compatibles con versiones anteriores

## Proceso de Release

### 1. Preparación
1. Asegurar que todos los cambios estén commiteados
2. Ejecutar tests completos
3. Actualizar documentación
4. Verificar cambios en dependencias

### 2. Crear Release
1. Crear tag con versión:
   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0"
   git push origin v1.0.0
   ```

2. El proceso automático:
   - Genera release notes
   - Crea release en GitHub
   - Construye y prueba el código
   - Despliega en Kubernetes

### 3. Verificación
1. Comprobar release notes generados
2. Verificar despliegue
3. Ejecutar pruebas de humo
4. Notificar al equipo

## Convención de Commits

Utilizamos [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` Nueva característica
- `fix:` Corrección de error
- `docs:` Cambios en documentación
- `style:` Cambios de formato
- `refactor:` Refactorización de código
- `test:` Adición o modificación de tests
- `chore:` Cambios en tareas de mantenimiento

## Breaking Changes

Para cambios que rompen compatibilidad:

1. Marcar en el mensaje de commit:
   ```
   feat: nueva característica
   
   BREAKING CHANGE: descripción del cambio
   ```

2. Incrementar versión MAJOR

## Dependencias

### Actualización de Dependencias
1. Verificar compatibilidad
2. Probar cambios
3. Documentar actualizaciones
4. Commit con prefijo `chore:`

### Versiones Específicas
- Usar versiones exactas en `pom.xml`
- Documentar razones para versiones específicas
- Mantener registro de actualizaciones

## Rollback

### Versiones Anteriores
1. Mantener tags de todas las versiones
2. Documentar cambios entre versiones
3. Probar proceso de rollback

### Procedimiento
1. Identificar versión objetivo
2. Ejecutar scripts de rollback
3. Verificar estado
4. Documentar proceso

## Monitoreo

### Métricas de Versión
- Tiempo entre releases
- Tasa de rollback
- Problemas por versión
- Tiempo de resolución

### Alertas
- Configurar alertas por versión
- Monitorear métricas clave
- Notificar problemas críticos 