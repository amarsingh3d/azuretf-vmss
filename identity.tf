# # Define the Managed Identity
# resource "azurerm_user_assigned_identity" "vmss-identity" {
#   name                = "${local.environment}-identity"
#   resource_group_name = azurerm_resource_group.myrg.name
#   location            = azurerm_resource_group.myrg.location
# }


