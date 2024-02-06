#sqlmi creation
#get current subscription
data "azurerm_subscription" "current" {}
data "azuread_group" "giissqloperation" {
  display_name = "G IIS SQL operation"
}
data "azurerm_client_config" "current" {}
data "azurerm_route_table" "route_table" {
  name = var.route_name
  resource_group_name = var.vnet_resource_group_name
}

# Create resource group
/*
resource "azurerm_resource_group" "rg" {
  name     = var.vnet_resource_group_name
  location = var.location
} */

 #Create security group
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.vnet_resource_group_name
}

# Create a virtual network
/*
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group_name
  address_space       = [var.address_space]  ///#["10.162.30.128/26"]
  location            = var.location
}
*/

# Create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.vnet_resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.address_prefixes]   ///#["10.162.30.128/27"]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]

  delegation {
    name = "managedinstancedelegation"

    service_delegation {
      name    = "Microsoft.Sql/managedInstances"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

# Associate subnet and the nsg
resource "azurerm_subnet_network_security_group_association" "network_security_group_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

#Create route table
/*
resource "azurerm_route_table" "route_table" {
  name                          = var.route_name
  location                      = var.location
  resource_group_name           = var.vnet_resource_group_name
  disable_bgp_route_propagation = false
  depends_on = [
    azurerm_subnet.subnet,
  ]
} */

# Associate subnet and the route table
resource "azurerm_subnet_route_table_association" "subnet_route_table_association" {
  subnet_id      = azurerm_subnet.subnet.id
  route_table_id = data.azurerm_route_table.route_table.id
}

resource "azurerm_network_security_rule" "AllowAzureLoadBalancerInbound" {
  name                        = "AllowAzureLoadBalancerInbound"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = var.vnet_resource_group_name
  network_security_group_name = var.nsg_name
}

resource "azurerm_network_security_rule" "AllowMIinternalInbound" {
  name                        = "AllowMIinternalInbound"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.address_prefixes
  destination_address_prefix  = var.address_prefixes
  resource_group_name         = var.vnet_resource_group_name
  network_security_group_name = var.nsg_name
}


resource "azurerm_network_security_rule" "AllowCommWithAADoverHttps" {
  name                        = "AllowCommWithAADoverHttps"
  priority                    = 106
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.address_prefixes
  destination_address_prefix  = "AzureActiveDirectory"
  resource_group_name         = var.vnet_resource_group_name
  network_security_group_name = var.nsg_name
}

resource "azurerm_network_security_rule" "AllowCommWithOneDSCollOverHttps" {
  name                        = "AllowCommWithOneDSCollOverHttps"
  priority                    = 107
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.address_prefixes
  destination_address_prefix  = "OneDsCollector"
  resource_group_name         = var.vnet_resource_group_name
  network_security_group_name = var.nsg_name
}

resource "azurerm_network_security_rule" "AllowMIinternalOutbound" {
  name                        = "AllowMIinternalOutbound"
  priority                    = 108
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.address_prefixes
  destination_address_prefix  = var.address_prefixes
  resource_group_name         = var.vnet_resource_group_name
  network_security_group_name = var.nsg_name
}

resource "azurerm_network_security_rule" "AllowOutboundWithWestStorageOverHTTPS" {
  name                        = "AllowOutboundWithWestStorageOverHTTPS"
  priority                    = 109
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.address_prefixes
  destination_address_prefix  = "Storage.westeurope"
  resource_group_name         = var.vnet_resource_group_name
  network_security_group_name = var.nsg_name
}

resource "azurerm_network_security_rule" "AllowOutboundWithNorthStorageOverHTTPS" {
  name                        = "AllowOutboundWithNorthStorageOverHTTPS"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.address_prefixes
  destination_address_prefix  = "Storage.northeurope"
  resource_group_name         = var.vnet_resource_group_name
  network_security_group_name = var.nsg_name
}

# Create managed instance
resource "azurerm_mssql_managed_instance" "managedinstance" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  license_type       = var.license_type
  sku_name           = var.sku_name
  storage_size_in_gb = var.storage_size_in_gb
  subnet_id          = azurerm_subnet.subnet.id
  vcores             = var.vcores
  storage_account_type = var.storage_account_type

  collation = var.collation
  timezone_id = var.timezone_id

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  minimum_tls_version          = "1.2"
  

   identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.network_security_group_association,
    azurerm_subnet_route_table_association.subnet_route_table_association,
  ]
   tags = var.common_tags
}

resource "azuread_group_member" "reader_member" {
  group_object_id   = var.admin_group #"GA SDSSQ00 SQL Directory Reader"
  member_object_id = azurerm_mssql_managed_instance.managedinstance.identity.0.principal_id
}


resource "azurerm_mssql_managed_instance_active_directory_administrator" "admin" {
  managed_instance_id =  azurerm_mssql_managed_instance.managedinstance.id
  login_username      = "G IIS SQL operation"
  object_id           = data.azuread_group.giissqloperation.object_id
  tenant_id           = data.azurerm_client_config.current.tenant_id #"de7e7a67-ae61-49d2-97a7-526c910ad675" #
  azuread_authentication_only = "true"
}

resource "azurerm_key_vault_access_policy" "access_policy" {
  key_vault_id = var.key_vault_id
  tenant_id = azurerm_mssql_managed_instance.managedinstance.identity[0].tenant_id
  object_id = azurerm_mssql_managed_instance.managedinstance.identity[0].principal_id

    key_permissions = [
      "Get", "WrapKey", "UnwrapKey"
    ]
}

resource "azurerm_mssql_managed_instance_transparent_data_encryption" "tde" {
  managed_instance_id = azurerm_mssql_managed_instance.managedinstance.id
  key_vault_key_id    = var.key_vault_key_id
}


resource "azurerm_mssql_managed_instance_security_alert_policy" "security_alert_policy" {
  resource_group_name        = var.resource_group_name
  managed_instance_name      = azurerm_mssql_managed_instance.managedinstance.name
  enabled                    = true
  storage_endpoint           = var.storage_endpoint #azurerm_storage_account.storrageaccount.primary_blob_endpoint
  storage_account_access_key = var.storage_account_access_key
  email_account_admins_enabled = true
  email_addresses = ["sql@if.se"]
  retention_days             = 7
}

resource "azurerm_mssql_managed_instance_vulnerability_assessment" "vulnerability_assessment" {
  managed_instance_id        = azurerm_mssql_managed_instance.managedinstance.id
  storage_container_path     = var.storage_container_path #"${azurerm_storage_account.storageaccount.primary_blob_endpoint}${azurerm_storage_container.container.name}/"
  storage_account_access_key = var.storage_account_access_key #azurerm_storage_account.storageaccount.primary_access_key

  recurring_scans {
    enabled                   = true
    email_subscription_admins = true
    emails = [
      "sql@if.se"
    ]
  }
  depends_on = [azurerm_mssql_managed_instance_security_alert_policy.security_alert_policy]
}