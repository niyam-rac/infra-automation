################################################ local variables ##################################################
locals {

}

############################################# resources to be deployed ############################################

resource "azurerm_service_plan" "appServicePlan" {
  resource_group_name = var.resourceGroupName
  location            = var.location
  tags                = var.tags
  name                = var.appServicePlanName
  os_type             = var.operatingSystem
  sku_name            = var.sku
}

output "appServicePlanId" {
  value       = azurerm_service_plan.appServicePlan.id
  description = "App Service Plan Id"
}
