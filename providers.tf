terraform {

  required_version = ">= 0.12.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0, < 4.0"
    }
    azuread = {
      version = "~> 2.19.1"
    }
  }

}

provider "azurerm" {
  features {
     key_vault {
      purge_soft_deleted_keys_on_destroy = true
      recover_soft_deleted_keys          = true
    }
  }
  storage_use_azuread        = false
  skip_provider_registration = true
}

