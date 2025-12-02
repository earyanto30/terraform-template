resource "azurerm_network_security_group" "nsg-ssh" {
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = "${var.prefix}-nsg-ssh"
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id     = azurerm_network_interface.ubuntu-vm.id
  network_security_group_id = azurerm_network_security_group.nsg-ssh.id
}