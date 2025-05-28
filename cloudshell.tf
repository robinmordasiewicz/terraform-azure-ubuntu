resource "azurerm_virtual_network" "cloudshell_network" {
  name                = "cloudshell-Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.azure_resource_group.location
  resource_group_name = azurerm_resource_group.azure_resource_group.name
}

resource "azurerm_subnet" "cloudshell_subnet" {
  name                 = "cloudshell-Subnet"
  resource_group_name  = azurerm_resource_group.azure_resource_group.name
  virtual_network_name = azurerm_virtual_network.cloudshell_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "cloudshell_public_ip" {
  name                = "cloudshell-PublicIP"
  location            = azurerm_resource_group.azure_resource_group.location
  resource_group_name = azurerm_resource_group.azure_resource_group.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "cloudshell_nsg" {
  name                = "cloudshell-NetworkSecurityGroup"
  location            = azurerm_resource_group.azure_resource_group.location
  resource_group_name = azurerm_resource_group.azure_resource_group.name
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
  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "cloudshell_nic" {
  name                = "cloudshell-NIC"
  location            = azurerm_resource_group.azure_resource_group.location
  resource_group_name = azurerm_resource_group.azure_resource_group.name

  ip_configuration {
    name                          = "cloudshell_nic_configuration"
    subnet_id                     = azurerm_subnet.cloudshell_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cloudshell_public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "cloudshell_nic_nsg_association" {
  network_interface_id      = azurerm_network_interface.cloudshell_nic.id
  network_security_group_id = azurerm_network_security_group.cloudshell_nsg.id
}

resource "random_id" "random_id" {
  keepers = {
    resource_group = azurerm_resource_group.azure_resource_group.name
  }
  byte_length = 8
}

resource "azurerm_storage_account" "cloudshell_storage_account" {
  name                     = "cldshl${random_id.random_id.hex}"
  location                 = azurerm_resource_group.azure_resource_group.location
  resource_group_name      = azurerm_resource_group.azure_resource_group.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_managed_disk" "home" {
  name                 = "${var.vm_name}-home-disk"
  location             = azurerm_resource_group.azure_resource_group.location
  resource_group_name  = azurerm_resource_group.azure_resource_group.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.home_disk_size_gb
}

resource "azurerm_managed_disk" "docker" {
  name                 = "${var.vm_name}-docker-disk"
  location             = azurerm_resource_group.azure_resource_group.location
  resource_group_name  = azurerm_resource_group.azure_resource_group.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.docker_disk_size_gb
}

resource "azurerm_linux_virtual_machine" "cloudshell_vm" {
  name                  = var.vm_name
  location              = azurerm_resource_group.azure_resource_group.location
  resource_group_name   = azurerm_resource_group.azure_resource_group.name
  network_interface_ids = [azurerm_network_interface.cloudshell_nic.id]
  size                  = "Standard_M16ms"
  #size = "Standard_D4s_v3"
  identity {
    type = "SystemAssigned"
  }
  custom_data = base64encode(
    templatefile("${path.module}/cloud-init/${var.vm_name}.conf",
      {
        VAR-Directory-tenant-ID = var.Directory-tenant-ID
        VAR-Directory-client-ID = var.Directory-client-ID
      }
    )
  )
  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 256
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
  computer_name  = "CLOUDSHELL"
  admin_username = var.username
  admin_ssh_key {
    username   = var.username
    public_key = azapi_resource_action.ssh_public_key_gen.output.publicKey
  }
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.cloudshell_storage_account.primary_blob_endpoint
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "home" {
  managed_disk_id    = azurerm_managed_disk.home.id
  virtual_machine_id = azurerm_linux_virtual_machine.cloudshell_vm.id
  lun                = 0
  caching            = "ReadOnly"
}

resource "azurerm_virtual_machine_data_disk_attachment" "docker" {
  managed_disk_id    = azurerm_managed_disk.docker.id
  virtual_machine_id = azurerm_linux_virtual_machine.cloudshell_vm.id
  lun                = 1
  #caching            = "ReadWrite"
  caching                   = "None"
  write_accelerator_enabled = true
}
