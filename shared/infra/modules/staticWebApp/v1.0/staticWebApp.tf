################################################ local variables ##################################################
locals {
  sku = "Standard"
}

################################################ existing resources ###############################################

############################################## resources to be deployed ###########################################

resource "azurerm_static_site" "staticWebApp" {
  resource_group_name = var.resourceGroupName
  location            = var.location
  name                = var.staticWebAppName
  tags                = var.tags
  sku_size            = local.sku
  sku_tier            = local.sku

  lifecycle {
    prevent_destroy = true
  }
}

output "defaultHostName" {
  value       = azurerm_static_site.staticWebApp.default_host_name
  description = "Static Web App Default Host Name"
}
