################################################ local variables ##################################################
locals {

}

############################################# resources to be deployed ############################################

resource "azurerm_application_insights" "appInsights" {
  resource_group_name        = var.resourceGroupName
  location                   = var.location
  application_type           = "web"
  internet_ingestion_enabled = true
  internet_query_enabled     = true
  disable_ip_masking         = false
  tags                       = var.tags
  name                       = var.appInsightsName
  workspace_id               = var.logAnalyticsId
}

output "appInsightsId" {
  value       = azurerm_application_insights.appInsights.id
  description = "App Insights Id"
}

output "instrumentationKey" {
  value       = azurerm_application_insights.appInsights.instrumentation_key
  description = "App Insights Instrumentation Key"
  sensitive   = true
}

output "connectionString" {
  value       = azurerm_application_insights.appInsights.connection_string
  description = "App Insights Connection String"
  sensitive   = true
}
