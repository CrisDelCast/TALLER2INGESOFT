# Política de Seguridad

## Escaneo de Vulnerabilidades

Este proyecto utiliza Trivy para el escaneo de vulnerabilidades en las imágenes Docker. El escaneo se realiza como parte del pipeline CI/CD para cada microservicio.

### Vulnerabilidades Conocidas

Hemos identificado varias vulnerabilidades en las dependencias de Spring Boot y otras bibliotecas. Estas vulnerabilidades han sido documentadas y aceptadas temporalmente para fines académicos, ya que:

1. Muchas son vulnerabilidades en dependencias transitivas de Spring Boot
2. La mayoría requieren actualizaciones mayores de Spring Boot (2.x a 3.x)
3. En un entorno de producción, estas vulnerabilidades serían mitigadas mediante:
   - Actualización a Spring Boot 3.x
   - Configuración de seguridad adicional
   - Implementación de WAF (Web Application Firewall)
   - Monitoreo y logging robusto

### Archivo .trivyignore

El archivo `.trivyignore` contiene una lista de vulnerabilidades conocidas que han sido aceptadas temporalmente. Estas vulnerabilidades están organizadas por categoría:

- Logback
- Jackson
- XStream
- Netty
- Reactor Netty
- Jettison
- Spring Boot
- Spring Security
- Spring Framework
- SnakeYAML

### Plan de Mitigación

En un entorno de producción, se implementarían las siguientes medidas:

1. **Actualización de Dependencias**
   - Migración a Spring Boot 3.x
   - Actualización de todas las dependencias a sus últimas versiones estables

2. **Configuración de Seguridad**
   - Implementación de headers de seguridad
   - Configuración de CORS
   - Rate limiting
   - Validación de entrada robusta

3. **Monitoreo y Logging**
   - Implementación de logging de seguridad
   - Monitoreo de intentos de acceso no autorizado
   - Alertas para actividades sospechosas

4. **Pruebas de Seguridad**
   - Escaneo de vulnerabilidades regular
   - Penetration testing
   - Code review enfocado en seguridad

## Reportar Vulnerabilidades

Si encuentras una vulnerabilidad de seguridad, por favor:

1. No la reportes públicamente
2. Contacta al equipo de desarrollo
3. Proporciona detalles sobre la vulnerabilidad
4. Espera la confirmación de recepción

## Actualizaciones de Seguridad

Las actualizaciones de seguridad se manejarán de la siguiente manera:

1. Evaluación de la severidad
2. Planificación de la mitigación
3. Implementación de la solución
4. Pruebas de regresión
5. Despliegue en producción 