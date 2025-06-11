environment            = "dev"
location              = "eastus"
storage_account_suffix = "dev123"  # Este valor debe ser único en Azure
address_space         = ["10.0.0.0/16"]
aks_subnet_prefix     = ["10.0.1.0/24"]
app_gateway_subnet_prefix = ["10.0.2.0/24"] 