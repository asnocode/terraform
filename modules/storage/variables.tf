variable "storage_account_name" {}

variable "resource_group_name" {}

variable "location" {}

variable "common_tags" {}

variable "access_tier" {}

variable "account_replication_type" {}

variable "blob_softdelete_days" {}

variable "container_softdelete_days" {}

variable "ip_rules" {}

variable "principal_id" {}

variable "subnet_id" {}

variable "containers_list" {}

/*
locals {
    flat_list = setproduct(var.staccount, var.containers_list)
} 
*/