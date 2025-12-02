resource "azurerm_virtual_machine" "ubuntu-vm" {
  name                  = "${var.prefix}-ubuntu-vm"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  vm_size               = "Standard_B2s"
  network_interface_ids = [azurerm_network_interface.ubuntu-vm.id]
  storage_os_disk {
    name          = "${var.prefix}-ubuntu-vm-disk"
    create_option = "FromImage"
    disk_size_gb  = 30
    caching       = "ReadWrite"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "ubuntu-pro"
    version   = "24.04.202510020"
  }
  os_profile {
    admin_username = "${var.admin_username}"
    computer_name  = "${var.prefix}-vm"
  }
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      key_data = azurerm_ssh_public_key.ubuntu-vm.public_key
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_ssh_public_key" "ubuntu-vm" {
  name                = "${var.prefix}-ubuntu-vm-sshkey"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  public_key          = "${var.ssh_public_key}"
}

resource "azurerm_network_interface" "ubuntu-vm" {
  name                = "${var.prefix}-ubuntu-vm-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.main.id
    public_ip_address_id          = azurerm_public_ip.ubuntu-vm.id
  }
}

resource "azurerm_public_ip" "ubuntu-vm" {
  name                = "${var.prefix}-ubuntu-vm-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  ip_version          = "IPv4"
  sku                 = "Standard"
  sku_tier            = "Regional"
}