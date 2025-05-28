variable "resource_group_location" {
  type        = string
  description = "The Azure region where the resource group will be created."
  default     = "eastus"
}

variable "username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "vscode"
}

variable "vm_name" {
  type        = string
  description = "Name of the VM"
  default     = "CLOUDSHELL"
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

variable "Directory-tenant-ID" {
  type        = string
  description = "The tenant ID of the Azure Active Directory."
  default     = "942b80cd-1b14-42a1-8dcf-4b21dece61ba"
}

variable "Directory-client-ID" {
  description = "The client ID of the Azure Active Directory application."
  type        = string
  default     = "38f03b3c-8001-46d6-a55e-af266c8cbd50"
}
