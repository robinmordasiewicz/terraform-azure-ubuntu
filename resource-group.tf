resource "azurerm_resource_group" "azure_resource_group" {
  location = var.resource_group_location
  name     = "40docs-cloudshell"
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"],
    ]
  }
}
