output "ssh_config_instructions" {
  description = "Instructions to set up SSH configuration for the VM."
  value       = <<EOF

1. Create the following file ~/.ssh/config with the content:

Host ${azurerm_linux_virtual_machine.cloudshell_vm[0].computer_name}
  HostName ${azurerm_linux_virtual_machine.cloudshell_vm[0].public_ip_address}
  ForwardAgent yes
  User ${azurerm_linux_virtual_machine.cloudshell_vm[0].admin_username}
  IdentityFile ~/.ssh/${azurerm_linux_virtual_machine.cloudshell_vm[0].computer_name}.pem

2. Create the file ~/.ssh/${azurerm_linux_virtual_machine.cloudshell_vm[0].computer_name} and save the private key using:

terraform output -raw key_data > ~/.ssh/${azurerm_linux_virtual_machine.cloudshell_vm[0].computer_name}.pem
chmod 600 ~/.ssh/${azurerm_linux_virtual_machine.cloudshell_vm[0].computer_name}.pem

EOF
}

output "key_data" {
  value     = azapi_resource_action.cloudshell_ssh_public_key_gen[0].output.privateKey
  sensitive = true
}
