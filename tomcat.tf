resource "azurerm_resource_group" "Tomcat-RG" {
  name = "Tomcat-RG"
  location = "Korea Central"
  depends_on = [ time_sleep.mysql-delay ]
}

resource "azurerm_virtual_network" "Tomcat-vn-network" {
  name = "Tomcat-RG-network"
  resource_group_name = azurerm_resource_group.Tomcat-RG.name
  location = azurerm_resource_group.Tomcat-RG.location
  address_space = [ "20.0.0.0/16" ]
}

resource "azurerm_subnet" "Tomcat-subnet" {
  name = "Tomcat-subnet"
  resource_group_name = azurerm_resource_group.Tomcat-RG.name
  virtual_network_name = azurerm_virtual_network.Tomcat-vn-network.name
  address_prefixes = [ "20.0.1.0/24" ]
}

resource "azurerm_network_interface" "Tomcat-network-interface" {
  name = "Tomcat-network-interface-testing"
  location = azurerm_resource_group.Tomcat-RG.location
  resource_group_name = azurerm_resource_group.Tomcat-RG.name
  ip_configuration {
    name = "Tomcat-ip-configuration"
    subnet_id = azurerm_subnet.Tomcat-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.Tomcat-public-ip.id
  }
}

resource "azurerm_public_ip" "Tomcat-public-ip" {
  name = "Tomcat-public-ip"
  location = azurerm_resource_group.Tomcat-RG.location
  resource_group_name = azurerm_resource_group.Tomcat-RG.name
  allocation_method = "Static"
  sku = "Standard"
}

resource "azurerm_virtual_machine" "testing-tomcat" {
  name = "testing_tomcat"
  location = azurerm_resource_group.Tomcat-RG.location
  resource_group_name = azurerm_resource_group.Tomcat-RG.name
  network_interface_ids = [ azurerm_network_interface.Tomcat-network-interface.id ]
  vm_size = "Standard_B1s"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  storage_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version = "latest"
  }
  storage_os_disk {
    name = "Tomcat-storage-os-disk"
    create_option = "FromImage"
    
  }
  os_profile {
    computer_name = "hostname"
    admin_username = "ubuntu"
    admin_password = "Tomcat1220."
    custom_data = file("tomcat.sh")
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_network_security_group" "tomcat-nsg" {
  name = "tomcat-nsg"
  location = azurerm_resource_group.Tomcat-RG.location
  resource_group_name = azurerm_resource_group.Tomcat-RG.name
  security_rule {
    name = "tomcat"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "8080"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "tomcat-sg" {
  network_interface_id      = azurerm_network_interface.Tomcat-network-interface.id
  network_security_group_id = azurerm_network_security_group.tomcat-nsg.id
}

resource "time_sleep" "tomcat-delay" {
  depends_on = [ azurerm_virtual_machine.testing-tomcat ]
  create_duration = "3m"
}

resource "azurerm_virtual_network_peering" "tomcat-mysql-peering" {
  name = "tomcat-mysql-peering"
  resource_group_name = azurerm_resource_group.Tomcat-RG.name
  virtual_network_name = azurerm_virtual_network.Tomcat-vn-network.name
  remote_virtual_network_id = azurerm_virtual_network.mysql-vn-network.id
}

resource "azurerm_virtual_network_peering" "tomcat-nginx-peering" {
  name = "tomcat-nginx-peering"
  resource_group_name = azurerm_resource_group.Tomcat-RG.name
  virtual_network_name = azurerm_virtual_network.Tomcat-vn-network.name
  remote_virtual_network_id = azurerm_virtual_network.nginx-vn-network.id
}

resource "azurerm_subnet" "bastion-subnet1" {
  name = "AzureBastionSubnet"
  resource_group_name = azurerm_resource_group.Tomcat-RG.name
  virtual_network_name = azurerm_virtual_network.Tomcat-vn-network.name
  address_prefixes = [ "20.0.2.0/26" ]
}

resource "azurerm_public_ip" "bastion-ip1" {
  name                = "bastion-ip"
  location            = azurerm_resource_group.Tomcat-RG.location
  resource_group_name = azurerm_resource_group.Tomcat-RG.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "TOMCAT-RG-network-bastion" {
  name                = "TOMCAT-RG-network-bastion"
  location            = azurerm_resource_group.Tomcat-RG.location
  resource_group_name = azurerm_resource_group.Tomcat-RG.name
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion-subnet1.id
    public_ip_address_id = azurerm_public_ip.bastion-ip1.id
  }
}