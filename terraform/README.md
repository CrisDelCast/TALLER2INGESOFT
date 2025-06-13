# Infraestructura como Código con Terraform

Este directorio contiene la configuración de Terraform para el proyecto de e-commerce.

## Estructura del Proyecto

```
terraform/
├── backend/              # Configuración del backend para el estado
├── environments/         # Configuraciones específicas por ambiente
│   ├── dev/             # Ambiente de desarrollo
│   ├── stage/           # Ambiente de staging
│   └── prod/            # Ambiente de producción
└── modules/             # Módulos reutilizables
    └── base/            # Módulo base con recursos comunes
```

## Arquitectura

La infraestructura está diseñada con los siguientes componentes:

1. **Backend Remoto**
   - Storage Account en Azure para almacenar el estado de Terraform
   - Container para organizar los estados por ambiente

2. **Módulo Base**
   - Resource Group
   - Virtual Network
   - Subnet
   - Network Security Group

3. **Ambientes**
   - Desarrollo (dev)
   - Staging (stage)
   - Producción (prod)

## Diagrama de Arquitectura

```
[Azure]
    │
    ├── Backend (Terraform State)
    │   └── Storage Account
    │       └── Container
    │
    └── Recursos por Ambiente
        ├── Resource Group
        ├── Virtual Network
        │   └── Subnet
        └── Network Security Group
```

## Uso

1. Inicializar el backend:
```bash
cd terraform/backend
terraform init
terraform apply
```

2. Desplegar un ambiente:
```bash
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

## Variables Requeridas

- `location`: Región de Azure (default: eastus)
- `environment`: Nombre del ambiente (dev, stage, prod)
- `tags`: Tags para los recursos

## Notas Importantes

- Cada ambiente tiene su propio estado en el backend
- Los recursos se crean con nombres únicos por ambiente
- Se aplican tags para mejor organización 