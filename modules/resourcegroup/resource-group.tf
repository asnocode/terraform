#Create resource group#
resource "azurerm_resource_group" "resourcegroup" {
  name     = var.resource_group_name #"rg-${var.project_name}-${var.environment}-${var.instance}-${var.number}"
  location = var.location
  tags     = var.common_tags
}