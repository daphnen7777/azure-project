resource "azurerm_resource_group" "Nginx-RG" {
  name = "Nginx-RG"
  location = "Korea Central"
  depends_on = [ time_sleep.tomcat-delay ]
}

resource "azurerm_virtual_network" "nginx-vn-network" {
  name = "Nginx-RG-network"
  resource_group_name = azurerm_resource_group.Nginx-RG.name
  location = azurerm_resource_group.Nginx-RG.location
  address_space = [ "10.0.0.0/16" ]
}

resource "azurerm_subnet" "nginx-subnet" {
  name = "nginx-subnet"
  resource_group_name = azurerm_resource_group.Nginx-RG.name
  virtual_network_name = azurerm_virtual_network.nginx-vn-network.name
  address_prefixes = [ "10.0.1.0/24" ]
}

resource "azurerm_network_interface" "nginx-network-interface" {
  name = "nginx-network-interface-testing"
  location = azurerm_resource_group.Nginx-RG.location
  resource_group_name = azurerm_resource_group.Nginx-RG.name
  ip_configuration {
    name = "nginx-ip-configuration"
    subnet_id = azurerm_subnet.nginx-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.nginx-public-ip.id
  }
}

resource "azurerm_public_ip" "nginx-public-ip" {
  name = "nginx-public-ip"
  location = azurerm_resource_group.Nginx-RG.location
  resource_group_name = azurerm_resource_group.Nginx-RG.name
  allocation_method = "Static"
  sku = "Standard"
}

resource "azurerm_virtual_machine" "testing-nginx" {
  name = "testing_nginx"
  location = azurerm_resource_group.Nginx-RG.location
  resource_group_name = azurerm_resource_group.Nginx-RG.name
  network_interface_ids = [ azurerm_network_interface.nginx-network-interface.id ]
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
    name = "nginx-storage-os-disk"
    create_option = "FromImage"
    
  }
  os_profile {
    computer_name = "hostname"
    admin_username = "ubuntu"
    admin_password = "Nginx1220."
    custom_data = file("nginx.sh")
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_network_security_group" "nginx-nsg" {
  name = "nginx-nsg"
  location = azurerm_resource_group.Nginx-RG.location
  resource_group_name = azurerm_resource_group.Nginx-RG.name
  security_rule {
    name = "http"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nginx-sg" {
  network_interface_id      = azurerm_network_interface.nginx-network-interface.id
  network_security_group_id = azurerm_network_security_group.nginx-nsg.id
}

output "nginx-nginx" {
  value = azurerm_public_ip.nginx-public-ip.ip_address
  description = "nginx public ip:"
}

resource "azurerm_virtual_network_peering" "nginx-tomcat-peering" {
  name = "nginx-tomcat-peering"
  resource_group_name = azurerm_resource_group.Nginx-RG.name
  virtual_network_name = azurerm_virtual_network.nginx-vn-network.name
  remote_virtual_network_id = azurerm_virtual_network.Tomcat-vn-network.id
}

resource "azurerm_subnet" "bastion-subnet2" {
  name = "AzureBastionSubnet"
  resource_group_name = azurerm_resource_group.Nginx-RG.name
  virtual_network_name = azurerm_virtual_network.nginx-vn-network.name
  address_prefixes = [ "10.0.2.0/26" ]
}

resource "azurerm_public_ip" "bastion-ip2" {
  name                = "bastion-ip"
  location            = azurerm_resource_group.Nginx-RG.location
  resource_group_name = azurerm_resource_group.Nginx-RG.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "NGINX-RG-network-bastion" {
  name                = "NGINX-RG-network-bastion"
  location            = azurerm_resource_group.Nginx-RG.location
  resource_group_name = azurerm_resource_group.Nginx-RG.name
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion-subnet2.id
    public_ip_address_id = azurerm_public_ip.bastion-ip2.id
  }
}