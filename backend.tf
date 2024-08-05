terraform {
  backend "azurerm" {
    resource_group_name  = "storage-rg"
    storage_account_name = "tfdev0098"
    container_name       = "terraform"
    key                  = "ishlappy.tfstate"

  }
}