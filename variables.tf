#values for vars defined in root
variable "resource_group_name" {
  type        = string
  description = "Enter the resorce group where you want to deploy the resources"
  default     = "rg-sqlmi-test-management"
}

#values for vars defined in envrionments
variable "resourcegroup" {
  description = "RG variables"
  type = map(object({
    resource_group_name  = string
  }))
  default = {
    st1 = {
    resource_group_name = "rg-sqlmi-test-management"
}
  }
}

variable "staccount" {
  description = "Storage account variables"
  type = map(object({
    resource_group_name  = string
    storage_account_name = string
    access_tier = string
    account_replication_type = string
    containers_list = list(string)
  }))
  default = {
    st1 = {
    resource_group_name = "rg-sqlmi-test-management"
    storage_account_name = "sasqlmistestmgnt"
    access_tier = "Hot"
    account_replication_type = "GRS"
    containers_list = ["backup", "vulnerability-assessment"]
}
  }
}

#values for vars defined in envrionments
variable "keyvault" {
  description = "Storage account variables"
  type = map(object({
    resource_group_name  = string
    keyvault_name = string
    key_name = string
  }))
  default = {
    st1 = {
    resource_group_name = "rg-sqlmi-test-management"
    keyvault_name = "kv-sqlmi-test"
    key_name = "sqlmi-st-db-01-TDE"
}
  }
}

variable "managedinstance" {
  description = "MI variables"
  type = map(object({
    resource_group_name     = string
    name                    = string
    nsg_name                = string
    subnet_name             = string
    storage_account_name    = string
  }))
  default = {
    st1 = {
    resource_group_name     = "rg-sqlmi-st-db-01"
    name                    = "sqlmi-st-db-01"
    nsg_name                = "nsg-sqlmi-st-db-01"
    subnet_name             = "snet-sqlmi-st-db-01"
    storage_account_name    = "stosqlmistdb01"
}
  }
}

# Common

 /*variable "nsg_name" {
  type        = string
  description = "name of nsg"
  default     = "nsg-sqlmi-st-db-01"
} 

 variable "subnet_name" {
  type        = string
  description = "name of subnet"
  default     = "snet-sqlmi-st-db-01"
} */

 variable "route_name" {
  type        = string
  description = "name of route"
  default     = "SQL-Hotel-Test-Network-UDR"
} 

  variable "subscription" {
  type        = string
  description = "name of subscription"
  default     = "c0723d0a-90a1-42b0-ba86-efd217b7483e"
  }

  variable "license_type" {
  type        = string
  description = "license_type"
  default     = "BasePrice"
  }

  variable "sku_name" {
  type        = string
  description = "sku"
  default = "standard"
  }           
  variable "storage_size_in_gb"  {
  type        = string
  description = "storage_size"
  default = 32
  }     
  variable "storage_account_type"  {
  type        = string
  description = "storage_size"
  default = "ZRS"
  }     
      
  variable "vcores"  {
  type        = string
  description = "vcore count"
  default = 4
  }      

  variable "address_space"   {
  type        = string
  description = "vnet address space"
  default = "10.162.30.128/26"
    }  

  variable "address_prefixes"   {
  type        = string
  description = "subnet address prefixes"
  default = "10.162.30.128/27"
    }      

  variable "administrator_login"  {
  type        = string
  description = "administrator login"
  default = "mi-poc-admin"
  }             
  variable "administrator_login_password"  {
  type        = string
  description = "administrator pass"
  default = "@%BTHNU^M&I*&U&%YY$TB%556574ytn"
  }     

  variable "identity"  {
  type = string
  description = "identitity"
  default = "SystemAssigned"
  }     


variable "containers_list" {
  type        = list(string)
  description = "name of container"
  default = ["backup", "vulnerability_assessment"]
} 


variable "project_name" {
  type        = string
  description = "name of project"
  default = "sqlmi"
}
variable "instance" {
  type        = string
  description = "number of instance"
  default = "db"
}
variable "number" {
  type        = string
  description = "number of instance"
  default = "01"
}
variable "location" {
  type        = string
  default     = "westeurope"
  description = "azure region where the resource is deployed."
}

variable "environment" {
  type        = string
  default     = "local"
  description = "deployment environment"
}

variable "collation" {
  type        = string
  default     = "Latin1_General_CI_AS"
  description = "deployment environment"
  }
  variable "timezone_id" {
  type        = string
  default     = "Central Europe Standard Time"
  description = "deployment environment"
}
variable "azure_tenant_id" {
  type        = string
  description = "azure deployment tenant id"
  default     = "de7e7a67-ae61-49d2-97a7-526c910ad675"
}

 variable "vnet_name" {
  type        = string
  description = "azure vnet name"
  default     = "SQL-Hotel-Test-Network"
}

  variable "vnet_resource_group_name" {
  type        = string
  description = "azure vnet rg"
  default     = "SQL-Hotel-Test-Network"
}


variable "whitelisted_if_ips" {
  type = list(object({
    name       = string
    ip_range   = string
    type       = string
  }))
  description = "access restrictions of ip for web app"
  default = [  
    {
    name     = "DK_Stamholmen"
    ip_range = "213.83.166.0/28"
    type     = "cidr"
  },
  {
    name     = "SE_Bergshamra"
    ip_range = "62.119.15.80/28"
    type     = "cidr"
  },]
}

variable "whitelisted_network_ids" {
    type = list(string)
    description = "network id for allowed subnets"
    default = ["/subscriptions/c0723d0a-90a1-42b0-ba86-efd217b7483e/resourceGroups/sql-hotel-test-network/providers/Microsoft.Network/virtualNetworks/sql-hotel-test-network/subnets/snet-sqlmi-st-db-02"]
}

/*variable "network_rules" {
  type = list(object({
    bypass   = list(string)
    default_action = string
    ip_rules       = list(string)
    virtual_network_subnet_ids = list(string)
  }))
  description = "acces restrictions of ip for web app"
  default = [{
    bypass                     = "AzureServices"
    default_action             = "Allow"
    ip_rules                   =  ["193.34.40.0/24", "195.190.141.0/24"]
    virtual_network_subnet_ids = ["/subscriptions/c0723d0a-90a1-42b0-ba86-efd217b7483e/resourceGroups/sql-hotel-test-network/providers/Microsoft.Network/virtualNetworks/sql-hotel-test-network/subnets/snet-sqlmi-st-db-02"]
  }]
} */

variable "ip_rules" {
    type = list(string)
    description = "network id for allowed subnets"
    default  =  ["193.34.40.0/24", "195.190.141.0/24"]
}

variable "admin_group" {
    type = string
    default = "bb34d711-75a0-42cc-9b7e-5bd293a248bb" # GA SDSSQ00 SQL Directory Reader
    description = "group that will have admin access to the key vault"
}
variable "readers" {
    type = list(string)
    description = "list of applications that will have read access to the key vault"
    default = ["sqlmi-st-db-02", "sqlmi-st-db-01"]
}

 variable "storage_container_path" {
  type        = string
  description = "azure storage container path"
  default     = "https://stosqlmistdb01.blob.core.windows.net/vulnerability-assessment"
}

 variable "storage_account_access_key" {
  type        = string
  description = "azure storage container key"
  default     = "snrSPxLLE1WDVziK7cWjaTwgCEmZQNky2yMbOBKr/w/9WPgZrgSDiZodeB5OHxdOMJ8ogQTb3S5q+ASt4/Ptxg==1"
}


 variable "storage_endpoint" {
  type        = string
  description = "azure storage container key"
  default     = "https://stosqlmistdb01.blob.core.windows.net"
}

 variable "principal_id" {
  type        = string
  description = "azure mi principal"
  default     = "bdb75e99-c398-4369-a498-36b33f2132f3"
}

 variable "key_vault_id" {
  type        = string
  description = "azure kv"
  default     = "/subscriptions/c0723d0a-90a1-42b0-ba86-efd217b7483e/resourceGroups/rg-sqlmi-test-management/providers/Microsoft.KeyVault/vaults/kv-sqlmi-test"
}

 variable "key_vault_key_id" {
  type        = string
  description = "azure kv key"
  default     = "https://kv-sqlmi-test.vault.azure.net/keys/sqlmi-st-db-01-TDE/2e43238ec76a4b909b888381dae7afc2"
}



