variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "vscode"
}

#variable "action-runner" {
#  type        = bool
#  default     = false
#  description = "Set to true if you want to create an action runner VM."
#}

variable "vm_name" {
  type        = string
  description = "Name of the VM"
  default     = "devcontainer"
}

variable "home_disk_size_gb" {
  type        = number
  description = "Size of the /home disk in GB"
  default     = 1024
}

variable "docker_disk_size_gb" {
  type        = number
  description = "Size of the Docker volume disk in GB"
  default     = 512
}
