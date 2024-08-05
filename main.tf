resource "azurerm_linux_virtual_machine" "example" {
  name                = "${local.environment}-vm"
  resource_group_name = resource.azurerm_resource_group.myrg.name
  location            = resource.azurerm_resource_group.myrg.location
  size                = var.vm_size
  admin_username      = data.azurerm_key_vault_secret.vmuser.value
  admin_password      = data.azurerm_key_vault_secret.vmpass.value

  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.linuxvmnic.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    name       = local.environment
    Automation = "Terraform"
  }
}


resource "azurerm_network_interface" "linuxvmnic" {
  name                = "${var.environment}-nic"
  location            = resource.azurerm_resource_group.myrg.location
  resource_group_name = resource.azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = resource.azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = resource.azurerm_public_ip.pubip.id
  }
}


resource "azurerm_public_ip" "pubip" {
  name                = "${local.environment}-pubip1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"

  tags = {
    environment = local.environment
  }
}

