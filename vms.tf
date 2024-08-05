resource "azurerm_linux_virtual_machine_scale_set" "linux-vmss" {
  name                = "${local.environment}-vmss"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  sku                 = var.vmss_size
  instances           = 1
  admin_username      = data.azurerm_key_vault_secret.vmuser.value
  custom_data         = filebase64("user-data-copy.sh")

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = data.azurerm_key_vault_secret.vmuser.value
    public_key = var.pub_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.mysubnet.id
      public_ip_address {
        name = "vmmspubip"
      }
    }


  }



}

