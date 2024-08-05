# Create an SSH key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "dedcon-vm" {
  name                = "dedcon-vm"
  resource_group_name = data.azurerm_resource_group.rg-prd-dedcon.name
  location            = data.azurerm_resource_group.rg-prd-dedcon.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.dedcon-vm-nic.id,
  ]

  # Using filebase64 to encode script
  custom_data = base64encode(data.template_file.setup_script.rendered)

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
