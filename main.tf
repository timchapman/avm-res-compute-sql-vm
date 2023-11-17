provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-VN"
  address_space       = [var.net_address_space]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "${var.prefix}-SN"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = [var.net_address_space_subnet]
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_public_ip" "vm" {
  name                = "${var.prefix}-PIP"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "example" {
  name                = "${var.prefix}-NSG"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_network_security_rule" "rdp_rule" {
  name                        = "RDPRule"
  resource_group_name         = azurerm_resource_group.example.name
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = var.rdp_port
  source_address_prefix       = "167.220.255.0/25"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "mssql_rule" {
  name                        = "MSSQLRule"
  resource_group_name         = azurerm_resource_group.example.name
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = var.mssql_port
  source_address_prefix       = "167.220.255.0/25"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_interface" "example" {
  name                = "${var.prefix}-NIC"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "exampleconfiguration1"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm.id
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_virtual_machine" "example" {
  name                  = "${var.prefix}-VM"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = var.vm_size

  /*
  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
*/
  storage_image_reference {
    publisher = local.current_settings.image_publisher
    offer     = local.current_settings.image_offer
    sku       = local.current_settings.image_sku
    version   = local.current_settings.image_version
  }

  storage_os_disk {
    name              = "${var.prefix}-OSDisk"
    caching           = "ReadOnly"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_windows_config {
    timezone                  = var.timezone
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
}

resource "azurerm_mssql_virtual_machine" "example" {
  virtual_machine_id = azurerm_virtual_machine.example.id
  sql_license_type   = "PAYG"
}

