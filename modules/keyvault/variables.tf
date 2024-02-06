variable "keyvault_name" {}
variable "key_name" {}
variable "resource_group_name" {}
variable "project_name" {}
variable "instance" {}
variable "location" {}
variable "azure_tenant_id" {}
variable "common_tags" {}
variable "environment" {}
variable "whitelisted_if_ips" {}
variable "ip_rules" {}
variable "admins" {
  default = []
}
variable "readers" {
  default = []
}
variable "enable_rbac_authorization" {}
variable  "enabled_for_deployment" {}
variable  "enabled_for_disk_encryption" {}
variable  "enabled_for_template_deployment" {}
variable  "public_network_access_enabled" {}
variable  "purge_protection_enabled" {}
variable  "sku_name" {}
variable  "soft_delete_retention_days" {}
variable  "tenant_id" {}

variable "admin_group" {}

variable "principal_id" {}

variable "subnet_id" {}


locals {
  admins     = concat(var.admins, tolist([var.admin_group]))
}

locals {
  ip_list = var.whitelisted_if_ips[*].ip_range
}