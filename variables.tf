variable "CLOUDSHELL" {
  type        = bool
  description = "Enable or disable the creation of the Azure Cloud Shell VM."
  default     = true
}

variable "resource_group_location" {
  type        = string
  description = "The Azure region where the resource group will be created."
  default     = "eastus"
}

variable "cloudshell_Directory_tenant_ID" {
  type        = string
  description = "The tenant ID of the Azure Active Directory."
  default     = "942b80cd-1b14-42a1-8dcf-4b21dece61ba"
}

variable "cloudshell_Directory_client_ID" {
  description = "The client ID of the Azure Active Directory application."
  type        = string
  default     = "38f03b3c-8001-46d6-a55e-af266c8cbd50"
}

variable "cloudshell_admin_username" {
  type        = string
  description = "The username for the Cloud Shell administrator."
  default     = "ubuntu"
}

variable "Forticnapp_account" {
  type        = string
  description = "The FortiCnapp account name."
  default     = "partner-demo"
}

variable "Forticnapp_subaccount" {
  type        = string
  description = "The FortiCnapp subaccount name."
  default     = "fortinetcanadademo"
}

variable "Forticnapp_api_key" {
  type        = string
  description = "The FortiCnapp api_key."
  default     = "FORTINET_A58D01E047E6BCEAB33F5DC15E83614EC845B6A8E05C3A4"
}

variable "Forticnapp_api_secret" {
  type        = string
  description = "The FortiCnapp api_secret."
  default     = "_55a65f52518be3a4de173d5bc5829f29"
}
