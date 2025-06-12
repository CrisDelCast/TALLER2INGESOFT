# Matriz de Responsabilidades

## Roles y Responsabilidades

### 1. Product Owner
- Aprobar cambios
- Priorizar implementaciones
- Evaluar impacto en negocio
- Comunicar a stakeholders

### 2. Tech Lead
- Revisar cambios técnicos
- Aprobar arquitectura
- Supervisar implementación
- Coordinar equipo técnico

### 3. DevOps Engineer
- Ejecutar scripts de rollback
- Monitorear sistemas
- Gestionar configuraciones
- Mantener infraestructura

### 4. QA Engineer
- Validar cambios
- Ejecutar pruebas
- Verificar rollbacks
- Reportar problemas

### 5. Developer
- Implementar cambios
- Crear tests
- Documentar código
- Asistir en rollbacks

## Proceso de Cambio

### Fase 1: Planificación
| Actividad | Product Owner | Tech Lead | DevOps | QA | Developer |
|-----------|--------------|-----------|--------|----|-----------|
| Crear RFC | R | C | I | I | I |
| Evaluar Impacto | R | C | I | I | I |
| Aprobar Cambio | R | C | I | I | I |
| Planificar Rollback | I | C | R | I | I |

### Fase 2: Implementación
| Actividad | Product Owner | Tech Lead | DevOps | QA | Developer |
|-----------|--------------|-----------|--------|----|-----------|
| Desarrollar | I | C | I | I | R |
| Revisar Código | I | R | I | I | C |
| Ejecutar Tests | I | I | I | R | C |
| Desplegar | I | C | R | I | I |

### Fase 3: Rollback
| Actividad | Product Owner | Tech Lead | DevOps | QA | Developer |
|-----------|--------------|-----------|--------|----|-----------|
| Decidir Rollback | R | C | I | I | I |
| Ejecutar Rollback | I | C | R | I | I |
| Verificar Estado | I | C | I | R | I |
| Documentar | I | C | I | I | R |

## Responsabilidades por Servicio

### API Gateway
- **Responsable Principal:** DevOps Engineer
- **Soporte:** Tech Lead
- **Verificación:** QA Engineer

### Microservicios
- **Responsable Principal:** Developer
- **Soporte:** Tech Lead
- **Verificación:** QA Engineer

### Base de Datos
- **Responsable Principal:** DevOps Engineer
- **Soporte:** Tech Lead
- **Verificación:** Developer

### Configuraciones
- **Responsable Principal:** DevOps Engineer
- **Soporte:** Tech Lead
- **Verificación:** QA Engineer

## Comunicación

### Canales de Comunicación
- **Cambios Críticos:** Email + Slack + Teams
- **Cambios Normales:** Slack + Jira
- **Rollbacks:** Email + Slack + Teams + PagerDuty

### Matriz de Escalamiento
1. Developer -> Tech Lead
2. Tech Lead -> Product Owner
3. Product Owner -> Director de Proyecto

## Documentación

### Responsables por Tipo
- **Documentación Técnica:** Developer
- **Documentación de Proceso:** Tech Lead
- **Documentación de Negocio:** Product Owner
- **Documentación de QA:** QA Engineer
- **Documentación de Infraestructura:** DevOps Engineer 