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

## 🌐 Arquitectura Lógica

![Diagrama Lógico](docs/img/diagrama_logico.svg)

> _Figura 1 – Diagrama lógico de microservicios, canales de comunicación y componentes externos._

---

## 🏗️ Infraestructura como Código (Terraform)

| Carpeta | Propósito |
|---------|-----------|
| `terraform/modules/network` | VNet / VPC, subredes, reglas de seguridad |
| `terraform/modules/kubernetes` | Creación del clúster AKS/EKS + Node Pools |
| `terraform/modules/database` | MySQL/PostgreSQL gestionado |
| `terraform/modules/monitoring` | Prometheus + Grafana helm charts |
| `terraform/envs/dev|stage|prod` | Variables específicas de cada ambiente |

```bash
# Ejemplo despliegue Stage
aws sso login               # o az login / gcloud auth
cd terraform/envs/stage
terraform init              # backend remoto ya configurado
terraform apply -var-file=stage.tfvars -auto-approve
```

> _Figura 2 – Captura de `terraform apply` con cambios planificados_  
> ![Terraform Apply](docs/img/terraform_plan.png)

---

## 🔄 Estrategia de Branching

```mermaid
flowchart LR
  A[main] -->|hotfix/*| H
  D[develop] -->|release/*| R
  D -->|feature/*| F1(( )) & F2(( ))
  R --> A
  H --> A
  F1 --> D
  F2 --> D
```

* **main**: solo código en producción.
* **develop**: integración continua.
* **feature/**: nuevas funcionalidades.
* **release/**: preparación de versiones.
* **hotfix/**: correcciones urgentes.

---

## ⚙️ CI/CD con Jenkins

![Pipeline Jenkins](docs/img/jenkins_pipeline.png)

Pasos clave:
1. **Build & Test** – `mvn test` + JaCoCo.
2. **Quality Gate** – SonarQube, Trivy.
3. **Build Image** – Docker + tag semver (`v${BUILD_NUMBER}`).
4. **Deploy Dev / Stage** – Helm upgrade, pruebas Integration/E2E.
5. **Aprobación manual** – despliegue a Producción.
6. **Post-deploy** – Locust + ZAP.

Snippet aprobación manual:
```groovy
input message: "¿Promocionar a producción?", ok: "Deploy"
```

---

## 🧪 Estrategia de Pruebas

| Tipo | Framework | Ubicación | Comando |
|------|-----------|-----------|---------|
| Unitarias | JUnit 5 + Mockito | `*/src/test/java` | `mvn test` |
| Integración | SpringBootTest + Testcontainers | `*IT.java` | `mvn verify` |
| E2E | JUnit 5 (Failsafe) | `test/java/com/.../EcommerceE2EFlowTest.java` | `mvn verify` |
| Rendimiento | Locust | `performance/` | `./run-performance-tests.sh` |
| Seguridad | OWASP ZAP | `performance/Jenkinsfile` | ejecutado en pipeline |

> _Figura 3 – Cobertura global JaCoCo_  
> ![JaCoCo](docs/img/jacoco_coverage.png)
>
> _Figura 4 – Reporte Locust_  
> ![Locust](docs/img/locust_overview.png)
>
> _Figura 5 – Reporte ZAP_  
> ![ZAP](docs/img/zap_overview.png)

---

## 📈 Observabilidad y Monitoreo

* **Prometheus** – recolección de métricas técnicas y de negocio (`/actuator/prometheus`).
* **Grafana** – dashboards `User Signup`, `Order Latency`, `CPU / Memory`.
* **ELK** – logs centralizados con filtrado por microservicio.
* **Jaeger** – trazas distribuidas.
* **Alertmanager** – alertas Slack `#alerts`.

![Dashboard Grafana](docs/img/grafana_dashboard.png)

---

## 🔐 Seguridad

* Escaneo de imágenes – **Trivy** en la etapa Build (`mvn clean package`).
* Escaneo dinámico – **OWASP ZAP Baseline** contra API Gateway.
* Gestión de secretos – **Kubernetes Secrets** + **Azure Key Vault** (en producción).
* RBAC K8s – políticas por namespace.

---

## 🛠️ Plan de Cambio & Release Notes

| Paso | Herramienta |
|------|-------------|
| Registrar cambio | Issue GitHub + plantilla |
| Desarrollo | Rama `feature/*` |
| PR + Revisión | 2 reviewers obligatorios |
| Merge a `develop` | Pipeline automático |
| Tag versión | Release-please Action |
| Publicar Release Notes | generados en Markdown |

*Ejemplo Release Notes:* **`docs/release/CHANGELOG_v1.1.0.md`**

---

## 💰 Costos de Infraestructura (mensual)

| Recurso | Dev | Stage | Prod |
|---------|-----|-------|------|
| AKS (3 nodos B4ms) | 90 USD | 180 USD | 360 USD |
| Azure Database MySQL | 35 | 70 | 140 |
| Blob Storage (tfstate) | 2 | 2 | 2 |
| Log Analytics + Grafana | 5 | 10 | 20 |
| **Total** | **132** | **262** | **522** |

> _Figura 6 – Captura Azure Cost Analysis_  
> ![Azure Cost](docs/img/azure_costs.png)

---

## 🚀 Despliegue en Kubernetes

```bash
# 1. Construir imagen local y subir al ACR/ECR
mvn -pl product-service clean package -DskipTests
az acr build -t product-service:v1 -r ecommerceacr .

# 2. Desplegar chart Helm (Dev)
helm upgrade --install product-service helm/product-service \
  --namespace dev \
  --set image.tag=v1

# 3. Verificar pods
kubectl get pods -n dev -w

# 4. Consultar logs
kubectl logs -f deployment/product-service -n dev

# 5. Rollback rápido
helm rollback product-service 1 -n dev
```

---

## 🗃️ Flujo Terraform – Ciclo de Vida Completo

```bash
# Crear nueva feature branch de infra
git checkout -b feature/tf-add-cache

# Formatear y validar
terraform fmt -recursive
terraform validate

# Previsualizar cambios en Stage
cd terraform/envs/stage
terraform plan -var-file=stage.tfvars -out=tfplan
terraform show tfplan

# Aplicar cambios
terraform apply tfplan

# Cuando se necesite destruir un entorno efímero
terraform destroy -var-file=dev.tfvars -auto-approve
```

---

## 🐳 Docker & Compose

```bash
# Build multi-arch para product-service
docker buildx build --platform linux/amd64,linux/arm64 \
  -t ecommerceacr.azurecr.io/product-service:latest . --push

# Levantar stack completo en local (Dev)
docker compose -f compose.yml up -d

docker compose ps
```

---

## 📂 Scripts de Mantenimiento

| Script | Descripción |
|--------|-------------|
| `scripts/backup-db.sh` | Crea dump de todas las BDs y lo sube a Blob Storage |
| `scripts/rotate-logs.sh` | Rota y comprime logs locales > 7 días |
| `scripts/scale.sh` | Aumenta réplicas via `kubectl scale` |

```bash
# ejemplo backup
./scripts/backup-db.sh --env stage --output backups/
```

---

## 🛡️ Validación de Seguridad Local

```bash
# Analizar vulnerabilidades de una imagen
trivy image ecommerceacr.azurecr.io/product-service:latest

# Escaneo ZAP (baseline)
docker run --rm -v $(pwd):/zap/wrk owasp/zap2docker-stable \
  zap-baseline.py -t http://localhost:8080 -r zap_local.html
```

---

## 🎥 Recursos Multimedia

* Video Demo – _pendiente de agregar enlace_  
* Presentación PDF – `docs/presentation/final.pdf`

---

## ✔️ Checklist de Control de Calidad

- [x] Despliegue automatizado pasando en Dev & Stage
- [x] 0 vulnerabilidades High (Trivy)
- [x] 0 hallazgos High (ZAP)
- [x] Cobertura líneas > 80 %
- [x] Latencia p95 < 250 ms (Locust)

---

> _Autor actualizado: Equipo IngeSoft V – 2025_



