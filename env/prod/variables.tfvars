#project_name            = "sqlmi"
#environment             = "pr"
#instance                = "db"
#number                  = "01"

resourcegroup = {
  "key01" = {
    resource_group_name     = "rg-sqlmi-pr-db-01"
  },
  "key02" = {
    resource_group_name     = "rg-sqlmi-prod-management"
  },
  "key03" = {
    resource_group_name     = "rg-sqlmi-prod-management-terraform"
  }
}

praccount = {
  "key01" = {
    resource_group_name     = "rg-sqlmi-pr-db-01"
    storage_account_name = "stosqlmiprdb01"
    access_tier = "Hot"
    account_replication_type = "GRS"
    containers_list = ["backup", "vulnerability-assessment"]
  },
    "key02" = {
    resource_group_name     = "rg-sqlmi-prod-management"
    storage_account_name = "stosqlmiprodmanagement"
    access_tier = "Hot"
    account_replication_type = "GRS"
    containers_list = ["common-sql", "terraform", "terraform-mgmt"]
  },
    "key03" = {
    resource_group_name     = "rg-sqlmi-prod-management-terraform"
    storage_account_name = "1zupa2e23ddddxx8pr01"
    access_tier = "Hot"
    account_replication_type = "GRS"
    containers_list = ["terraform"]
  },
  "key04" = {
    resource_group_name     = "rg-sqlmi-prod-management-terraform"
    storage_account_name = "1zupa2e23ddddxx8pr02"
    access_tier = "Hot"
    account_replication_type = "GRS"
    containers_list = ["terraform"]
  }
}

keyvault = {
  "key01" = {
    resource_group_name  = "rg-sqlmi-prod-management"
    keyvault_name = "kv-sqlmi-prod"
    key_name = "sqlmi-pr-db-01-TDE"
  }
}

managedinstance = {
  "key01" = {
resource_group_name     = "rg-sqlmi-pr-db-01" #"rg-${var.project_name}-${var.environment}-${var.instance}-${var.number}"
name                    = "sqlmi-pr-db-01" #"${var.project_name}-${var.environment}-${var.instance}-${var.number}"
nsg_name                = "nsg-sqlmi-pr-db-01" #"nsg-${var.project_name}-${var.environment}-${var.instance}-${var.number}"
subnet_name             = "snet-sqlmi-pr-db-01" #"snet-${var.project_name}-${var.environment}-${var.instance}-${var.number}"
storage_account_name    = "stosqlmiprdb01" #"sto${var.project_name}${var.environment}${var.instance}${var.number}"
 }
}

# Common
location                = "westeurope"
subscription            = "ca352517-27bb-41fc-98e0-22e58196594e"
azure_tenant_id         = "de7e7a67-ae61-49d2-97a7-526c910ad675" 

vnet_resource_group_name  = "SQL-Hotel-prod-Network"
vnet_name = "SQL-Hotel-prod-Network"
route_name = "SQL-Hotel-prod-Network-UDR"
address_space = "10.162.30.128/26"
address_prefixes = "10.162.30.128/27"

ip_rules = ["193.34.40.0/24", "195.190.141.0/24"]

storage_container_path = "https://stosqlmiprdb01.blob.core.windows.net/vulnerability-assessment"

license_type = "BasePrice"
sku_name           = "GP_Gen5"
storage_size_in_gb = 32
vcores             = 4
storage_account_type = "GRS"

administrator_login          = "mi-poc-admin"
administrator_login_password = "@%BTHNU^M&I*&U&%YY$TB%556574ytn"

admin_group =  "bb34d711-75a0-42cc-9b7e-5bd293a248bb" #"GA SDSSQ00 SQL Directory Reader"