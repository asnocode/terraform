#get current subscription
data "azurerm_subscription" "current" {}

#resourcegroup creation
module "resource-group" {
  source               = "./modules/resourcegroup"
  for_each = var.resourcegroup
  resource_group_name = each.value["resource_group_name"]
  location             = var.location  
  project_name = var.project_name
  instance = var.instance
  environment = var.environment
  number = var.number
  common_tags = local.common_tags
}

#storage creation
module "storage-account" {
  source               = "./modules/storage"
  for_each             = var.staccount
  resource_group_name  = each.value["resource_group_name"]
  location             = var.location
  common_tags          = local.common_tags
  storage_account_name = each.value["storage_account_name"]
  containers_list = each.value["containers_list"]
  access_tier = each.value["access_tier"]
  account_replication_type = each.value["account_replication_type"]
  blob_softdelete_days      = 7
  container_softdelete_days = 7
  ip_rules = var.ip_rules
  principal_id = module.managed-instance["key01"].principal_id
  subnet_id = module.managed-instance["key01"].subnet_id
}


#keyvault creation
module "key-vault" {
  source                  = "./modules/keyvault"
  for_each = var.keyvault
  keyvault_name = each.value["keyvault_name"] 
  key_name = each.value["key_name"]
  resource_group_name = each.value["resource_group_name"]
  project_name            = var.project_name
  instance                = var.instance
  location                = var.location
  azure_tenant_id         = var.azure_tenant_id
  environment             = var.environment
  ip_rules = var.ip_rules
  whitelisted_if_ips      = []
  admin_group             = var.admin_group
  readers                 = []
  enable_rbac_authorization       = true
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  public_network_access_enabled   = true
  purge_protection_enabled        = true
  sku_name                        = "standard"
  soft_delete_retention_days      = 90 
  common_tags = local.common_tags
  tenant_id = data.azurerm_subscription.current.tenant_id
  principal_id = module.managed-instance["key01"].principal_id
  subnet_id = module.managed-instance["key01"].subnet_id
}

#sqlmi creation
module "managed-instance" {
  source  = "./modules/mi"
  project_name = var.project_name
  environment= var.environment
  instance = var.instance
  number = var.number
  for_each = var.managedinstance
  name = each.value["name"]
  resource_group_name = each.value["resource_group_name"]
  location            = var.location
  license_type       = var.license_type
  sku_name           = var.sku_name
  storage_size_in_gb = var.storage_size_in_gb
  vcores             = var.vcores 
  storage_account_type = var.storage_account_type
  address_space = var.address_space
  address_prefixes = var.address_prefixes
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  admin_group = var.admin_group
  public_network_access_enabled = "False"
  collation = var.collation
  timezone_id = var.timezone_id
  vnet_name = var.vnet_name
  vnet_resource_group_name = var.vnet_resource_group_name
  nsg_name  =  each.value["nsg_name"]
  subnet_name = each.value["subnet_name"]
  route_name = var.route_name 

   identity = {
    type = "SystemAssigned"
  }

  common_tags = local.common_tags

  key_vault_key_id = module.key-vault[each.key].key_vault_key_id
  key_vault_id =  module.key-vault[each.key].key_vault_id

  storage_account_access_key = module.storage-account["key01"].primary_access_key
  storage_endpoint =  module.storage-account["key01"].primary_blob_endpoint
  storage_container_path = var.storage_container_path #"${azurerm_storage_account.storageaccount.primary_blob_endpoint}${azurerm_storage_container.container.name}/"
  }




