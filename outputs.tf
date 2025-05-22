output "resource_group_name" {
  description = "The name of the resource group where the VM is deployed."
  value       = azurerm_resource_group.rg.name
}

output "public_ip_address" {
  description = "The public IP address of the Linux VM."
  value       = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}

output "ssh_config_instructions" {
  description = "Instructions to set up SSH configuration for the VM."
  value       = <<EOF

1. Create the following file ~/.ssh/config with the content:

Host devcontainer
  HostName ${azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address}
  User vscode
  ForwardAgent yes
  IdentityFile ~/.ssh/devcontainer

2. Create the file ~/.ssh/devcontainer and save the private key using:

terraform output -raw key_data > ~/.ssh/devcontainer

EOF
}
