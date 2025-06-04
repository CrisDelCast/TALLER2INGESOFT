# 🚀 Taller 2: E-commerce Microservices Backend
### Sistema de Microservicios con Jenkins y Kubernetes

---

##  Descripción del Proyecto

Sistema de microservicios e-commerce con arquitectura distribuida:
- ✅ **6 microservicios** principales
- ✅ **Jenkins** para CI/CD
- ✅ **Kubernetes** para orquestación
- ✅ **Spring Cloud** para gestión de servicios

---

---

## Inicio Rápido

```bash
# 1. Iniciar Jenkins
./start-jenkins.sh

# 2. Verificar servicios
docker-compose -f docker-compose.dev.yml up -d

# 3. Acceder a Jenkins
http://localhost:8081
```

---

##  Credenciales

**Jenkins:**
- URL: http://localhost:8080
-  Contraseña inicial: Se obtiene con:
  ```bash
  docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
  ```

---

## Microservicios

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| **API Gateway** | 8080 | Punto de entrada único para todos los servicios |
| **Cloud Config** | 8888 | Configuración centralizada |
| **Service Discovery** | 8761 | Registro de servicios (Eureka) |
| **Order Service** | 8081 | Gestión de órdenes |
| **Product Service** | 8082 | Catálogo de productos |
| **User Service** | 8083 | Gestión de usuarios |

---

## Tecnologías Utilizadas

- **Backend**: Spring Boot, Spring Cloud
- **Base de Datos**: PostgreSQL
- **CI/CD**: Jenkins
- **Contenedores**: Docker
- **Orquestación**: Kubernetes
- **Service Discovery**: Eureka
- **Configuración**: Spring Cloud Config

---

## Scripts Disponibles

| Script | Descripción |
|--------|-------------|
| `start-jenkins.sh` | Inicia Jenkins en Docker |
| `restart-jenkins.sh` | Reinicia Jenkins |
| `docker-compose.dev.yml` | Configuración de desarrollo |
| `docker-compose.jenkins.yml` | Configuración de Jenkins |

---

##  Pruebas

### Pruebas Unitarias
- UserService
- OrderService
- ProductService

### Pruebas de Integración
- API Gateway
- Service Discovery
- Cloud Config

---

## Estructura del Proyecto

```
TALLER2INGESOFT/
├──  Microservicios
│   ├── api-gateway/
│   ├── cloud-config/
│   ├── order-service/
│   ├── product-service/
│   ├── service-discovery/
│   └── user-service/
├──  Jenkins
│   ├── docker-compose.jenkins.yml
│   ├── start-jenkins.sh
│   └── restart-jenkins.sh
├── Kubernetes
│   └── k8s/
└── Configuración
    ├── docker-compose.dev.yml
    └── compose.yml
```

---

##  Comandos Útiles

```bash
# Ver logs de Jenkins
docker-compose -f docker-compose.jenkins.yml logs jenkins

# Ver servicios en ejecución
docker-compose -f docker-compose.dev.yml ps

# Acceder a Jenkins
http://localhost:8080

# Ver logs de un microservicio
docker-compose -f docker-compose.dev.yml logs -f [servicio]
```

---

## Troubleshooting

### Jenkins no inicia
```bash
# Verificar logs
docker-compose -f docker-compose.jenkins.yml logs jenkins

# Reiniciar Jenkins
./restart-jenkins.sh
```

### Microservicios no responden
```bash
# Verificar estado
docker-compose -f docker-compose.dev.yml ps

# Reiniciar servicios
docker-compose -f docker-compose.dev.yml restart
```

---

