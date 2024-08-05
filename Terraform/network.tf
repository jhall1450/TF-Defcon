# Create public IPs
resource "azurerm_public_ip" "dedcon-pub-ip" {
  name                = "dedcon-pub-ip"
  location            = data.azurerm_resource_group.rg-prd-dedcon.location
  resource_group_name = data.azurerm_resource_group.rg-prd-dedcon.name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network" "dedcon-vnet" {
  name                = "dedcon-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.rg-prd-dedcon.location
  resource_group_name = data.azurerm_resource_group.rg-prd-dedcon.name
}

resource "azurerm_subnet" "dedcon-snet" {
  name                 = "dedcon-snet"
  resource_group_name  = data.azurerm_resource_group.rg-prd-dedcon.name
  virtual_network_name = azurerm_virtual_network.dedcon-vnet.name
  address_prefixes     = ["10.0.10.0/29"]
}

resource "azurerm_network_interface" "dedcon-vm-nic" {
  name                = "dedcon-vm-nic"
  location            = data.azurerm_resource_group.rg-prd-dedcon.location
  resource_group_name = data.azurerm_resource_group.rg-prd-dedcon.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.dedcon-snet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dedcon-pub-ip.id
  }
}

resource "azurerm_network_security_rule" "ssh-rule" {
  resource_group_name         = data.azurerm_resource_group.rg-prd-dedcon.name
  network_security_group_name = azurerm_network_security_group.dedcon-nsg.name
  name                        = "SSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "dedcon-rule" {
  resource_group_name         = data.azurerm_resource_group.rg-prd-dedcon.name
  network_security_group_name = azurerm_network_security_group.dedcon-nsg.name
  name                        = "dedcon"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = var.dedcon_server_port
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "dedcon-nsg" {
  name                = "dedcon-nsg"
  location            = data.azurerm_resource_group.rg-prd-dedcon.location
  resource_group_name = data.azurerm_resource_group.rg-prd-dedcon.name
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "dedcon-nsg-link" {
  network_interface_id      = azurerm_network_interface.dedcon-vm-nic.id
  network_security_group_id = azurerm_network_security_group.dedcon-nsg.id
}
