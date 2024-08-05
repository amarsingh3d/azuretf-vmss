data "azurerm_client_config" "current" {}
#####################################################################################
#                    Key Vault                                                      #
#####################################################################################

resource "azurerm_key_vault" "mykeyvault1" {
  name                        = "${local.environment}-vmsskeyvault1"
  location                    = azurerm_resource_group.myrg.location
  resource_group_name         = azurerm_resource_group.myrg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"


}
// Grant Write Permission to Current Terraform Identity
resource "azurerm_key_vault_access_policy" "vaultkeypolicy" {
  key_vault_id = azurerm_key_vault.mykeyvault1.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["Set", "Get", "Delete", "Purge", "Recover"]
  key_permissions    = ["Create", "Get"]
}

// Grant Write Permission to Current Given Identity
resource "azurerm_key_vault_access_policy" "mykeyvault-policy1" {
  key_vault_id       = azurerm_key_vault.mykeyvault1.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = "90425bc9-33bd-4ef2-aea7-a31723dc869c"
  key_permissions    = ["Get", "List"]
  secret_permissions = ["Get", "List"]

}
//  Granting permission to VMSS System Managed Identity
resource "azurerm_key_vault_access_policy" "vmsspolicy" {
  key_vault_id = azurerm_key_vault.mykeyvault1.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_virtual_machine_scale_set.linux-vmss.identity[0].principal_id

  secret_permissions = ["Get", "List"]
}
// Create New Secret to KeyVault
resource "azurerm_key_vault_secret" "gituser1" {

  name         = "azuregituser"
  value        = var.gituser
  key_vault_id = azurerm_key_vault.mykeyvault1.id
}
// Create New secret to KeyVault
resource "azurerm_key_vault_secret" "gitpass1" {
  name         = "azuregitpass"
  value        = var.gitpass
  key_vault_id = azurerm_key_vault.mykeyvault1.id
}