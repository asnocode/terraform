data "azurerm_subscription" "current" {}
# Create storage account
resource "azurerm_storage_account" "storageaccount" {
  name                              = var.storage_account_name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  account_tier                      = "Standard"
  account_replication_type          = var.account_replication_type
  public_network_access_enabled     = "true"
  allow_nested_items_to_be_public   = "false"
  account_kind                      = "StorageV2"
  access_tier                       = var.access_tier
  min_tls_version                   = "TLS1_2"
  identity {
    type = "SystemAssigned"
  }
  network_rules {
    bypass   = ["AzureServices"]
    default_action = "Deny" //"Allow"
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids =  [var.subnet_id]
  }
  blob_properties {
    delete_retention_policy {
      days = var.blob_softdelete_days
    }
    container_delete_retention_policy {
      days = var.container_softdelete_days
    }
  }
  tags = var.common_tags

}

resource "azurerm_storage_container" "container"  {
  for_each = toset(var.containers_list)
  name  = each.value
  storage_account_name  = var.storage_account_name
  container_access_type = "private"
}

resource "azurerm_advanced_threat_protection" "advanced_threat_protection" {
  target_resource_id = azurerm_storage_account.storageaccount.id
  enabled            = true
}

resource "azurerm_role_assignment" "role-assignment" {
  scope                = azurerm_storage_account.storageaccount.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         =  var.principal_id #azurerm_mssql_managed_instance.managedinstance.identity.0.principal_id
}



