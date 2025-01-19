################################################ local variables ##################################################
locals {
  dailyQuotaGb = var.dailyQuotaGb < 1 ? -1 : var.dailyQuotaGb // unlimited = -1
}

############################################# resources to be deployed ############################################

resource "azurerm_log_analytics_workspace" "logAnalyticsWorkspace" {
  resource_group_name = var.resourceGroupName
  location            = var.location
  tags                = var.tags
  name                = var.logAnalyticsName
  sku                 = var.sku
  retention_in_days   = var.dataRetentionInDays
  daily_quota_gb      = local.dailyQuotaGb
}

output "logAnalyticsId" {
  value       = azurerm_log_analytics_workspace.logAnalyticsWorkspace.id
  description = "Log Analytics Workspace Id"
}
