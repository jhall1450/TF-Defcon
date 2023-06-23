# Create public IPs
resource "azurerm_public_ip" "defcon-pub-ip" {
  name                = "defcon-pub-ip"
  location            = azurerm_resource_group.rg-prd-defcon.location
  resource_group_name = azurerm_resource_group.rg-prd-defcon.name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network" "rg-vnet" {
  name                = "rg-nsg"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg-prd-defcon.location
  resource_group_name = azurerm_resource_group.rg-prd-defcon.name
}

resource "azurerm_subnet" "defcon-snet" {
  name                 = "defcon-snet"
  resource_group_name  = azurerm_resource_group.rg-prd-defcon.name
  virtual_network_name = azurerm_virtual_network.rg-vnet.name
  address_prefixes     = ["10.0.10.0/29"]
}

resource "azurerm_network_interface" "defcon-vm-nic" {
  name                = "defcon-vm-nic"
  location            = azurerm_resource_group.rg-prd-defcon.location
  resource_group_name = azurerm_resource_group.rg-prd-defcon.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.defcon-snet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.defcon-pub-ip.id
  }
}

resource "azurerm_network_security_rule" "ssh-rule" {
  resource_group_name         = azurerm_resource_group.rg-prd-defcon.name
  network_security_group_name = azurerm_network_security_group.defcon-nsg.name
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

resource "azurerm_network_security_rule" "defcon-rule" {
  resource_group_name         = azurerm_resource_group.rg-prd-defcon.name
  network_security_group_name = azurerm_network_security_group.defcon-nsg.name
  name                        = "Defcon"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "5010"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "defcon-nsg" {
  name                = "defcon-nsg"
  location            = azurerm_resource_group.rg-prd-defcon.location
  resource_group_name = azurerm_resource_group.rg-prd-defcon.name
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "defcon-nsg-link" {
  network_interface_id      = azurerm_network_interface.defcon-vm-nic.id
  network_security_group_id = azurerm_network_security_group.defcon-nsg.id
}
