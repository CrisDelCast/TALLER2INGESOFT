# Endpoints y Puntos de Monitoreo

## 1. Endpoints de Health Check

### API Gateway
```
GET /actuator/health
GET /actuator/info
GET /actuator/metrics
```

### Microservicios
```
GET /actuator/health
GET /actuator/info
GET /actuator/metrics
GET /actuator/prometheus
```

### Servicios de Configuración
```
GET /actuator/health
GET /actuator/refresh
GET /actuator/bus-refresh
```

## 2. Métricas Específicas

### Métricas de Cambios
```
# Tiempo de implementación
change_implementation_duration_seconds

# Tasa de éxito
change_success_rate

# Tasa de rollback
change_rollback_rate

# Tiempo de detección de problemas
change_problem_detection_seconds
```

### Métricas de Rollback
```
# Tiempo de rollback
rollback_duration_seconds

# Estado de backup
backup_status

# Tiempo de restauración
restore_duration_seconds
```

### Métricas de Calidad
```
# Tests pasados
tests_passed_total

# Cobertura de código
code_coverage_percentage

# Calidad de código
code_quality_score
```

## 3. Logs Específicos

### Eventos de Cambio
```json
{
  "timestamp": "ISO-8601",
  "level": "INFO|WARN|ERROR",
  "event": "CHANGE_START|CHANGE_END|ROLLBACK_START|ROLLBACK_END",
  "changeId": "string",
  "service": "string",
  "details": "object"
}
```

### Eventos de Rollback
```json
{
  "timestamp": "ISO-8601",
  "level": "INFO|WARN|ERROR",
  "event": "ROLLBACK_START|ROLLBACK_END|ROLLBACK_FAILED",
  "changeId": "string",
  "service": "string",
  "reason": "string",
  "details": "object"
}
```

## 4. Traces

### Spans de Cambio
```
change.implementation
change.verification
change.rollback
change.cleanup
```

### Tags de Traza
```
change.id
change.type
service.name
environment
```

## 5. Alertas

### Condiciones de Alerta
```
# Rollback fallido
change_rollback_failed > 0

# Tiempo de implementación excesivo
change_implementation_duration_seconds > 3600

# Tasa de éxito baja
change_success_rate < 0.95

# Problemas de backup
backup_status != 1
```

### Canales de Alerta
- Email
- Slack
- PagerDuty
- Teams

## 6. Dashboards

### Métricas a Mostrar
- Tasa de éxito de cambios
- Tiempo promedio de implementación
- Tasa de rollback
- Problemas comunes
- Estado de servicios
- Métricas de calidad

### Gráficos
- Tendencias de cambios
- Distribución de tiempos
- Causas de rollback
- Impacto en usuarios
- Costos de cambios 