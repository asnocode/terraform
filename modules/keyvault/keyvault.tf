#get current subscription
data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}
data "azuread_group" "giissqloperation" {
  display_name = "G IIS SQL operation"
}

resource "azurerm_resource_group" "resourcegroup_mgmnt" {
  name     = var.resource_group_name
  location = var.location
}

# Create a key vault with policies for the deployer to create a key & SQL Managed Instance to wrap/unwrap/get key

resource "azurerm_key_vault" "keyvault" {
  name                            = var.keyvault_name 
  resource_group_name             = var.resource_group_name
  location                        = var.location
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  tenant_id                       = var.azure_tenant_id
  tags                            = var.common_tags
  sku_name                        = "standard"
  soft_delete_retention_days      = 90
  purge_protection_enabled        = true
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

      key_permissions = [
      "Create",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Update",
      "GetRotationPolicy",
      "SetRotationPolicy"
    ]

    secret_permissions = [
      "Set",
      "Get",
      "List"
    ]
  } 

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids =  [var.subnet_id]
  }

/*
  # Admins
  dynamic "access_policy" {
    for_each = local.admins
    content {
      tenant_id       = var.azure_tenant_id
      object_id       = access_policy.value
      key_permissions = []
      secret_permissions = [
        "Get",
        "List",
        "Set",
        "Delete",
        "Recover",
        "Backup",
        "Restore"
      ]
      certificate_permissions = []
    }
  }

  # readers
  dynamic "access_policy" {
    for_each = var.readers
    content {
      tenant_id       = var.azure_tenant_id
      object_id       = access_policy.value
      key_permissions = []
      secret_permissions = [
        "Get",
        "List"
      ]
      certificate_permissions = []
    }
  }
  */
}


#G IIS SQL operation permissions on keyvault
resource "azurerm_role_assignment" "keyvaultroleassignment" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_group.giissqloperation.id #"a6eb261a-8bb5-46fa-b88e-b79b078e7e7f"
}

resource "azurerm_role_assignment" "sqlmiroleassignment" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = var.principal_id
}


resource "azurerm_key_vault_key" "keyvaultkey" {
  name         = var.key_name
  key_vault_id = azurerm_key_vault.keyvault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  depends_on = [
    azurerm_key_vault.keyvault
  ]
}




