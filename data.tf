locals {
  environment    = "dev"
  sec_rg         = "dev-rg"
  rg_name        = "dev-rg-asia"
  vnet_name      = "dev-vnet"
  key_vault_name = "my-terraform-secrets"
  linux_vm_user  = "vmuser"
  linux_vm_pass  = "vmpass"
  pub_subnet     = "public_subnet1"
  rg_location    = "East Asia"
  cidr           = ["10.0.0.0/16"]
}

resource "azurerm_resource_group" "myrg" {
  name     = local.rg_name
  location = local.rg_location

}

resource "azurerm_virtual_network" "myvnet" {
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  name                = "${local.environment}-vnet"
  address_space       = local.cidr

}
resource "azurerm_subnet" "mysubnet" {
  resource_group_name  = azurerm_resource_group.myrg.name
  address_prefixes     = ["10.0.1.0/24"]
  name                 = "${local.environment}-public_subnet1"
  virtual_network_name = "${local.environment}-vnet"


}

data "azurerm_key_vault" "tfkeyvault" {
  name                = local.key_vault_name
  resource_group_name = local.sec_rg

}

data "azurerm_key_vault_secret" "vmuser" {
  name         = local.linux_vm_user
  key_vault_id = data.azurerm_key_vault.tfkeyvault.id

}

data "azurerm_key_vault_secret" "vmpass" {
  name         = local.linux_vm_pass
  key_vault_id = data.azurerm_key_vault.tfkeyvault.id
}


