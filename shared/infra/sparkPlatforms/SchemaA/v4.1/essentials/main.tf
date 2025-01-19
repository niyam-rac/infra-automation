########################################### local variables #######################################################
locals {
  operatingSystem = (lower(var.appServicePlan.operatingSystem) == "windows") ? "Windows" : "Linux"
}

########################################### existing resources ####################################################

data "azurerm_resource_group" "projectResourceGroup" {
  name = var.projectResourceGroupName
}

data "azurerm_resource_group" "dataStorageResourceGroup" {
  count = var.dataStorageAccount.enable ? 1 : 0
  name  = var.dataStorageAccount.resourceGroupName
}

######################################## module resources to be deployed ##########################################

module "logAnalyticsModules" {
  source = "../../../../modules/logAnalytics/v1.0"

  resourceGroupName   = data.azurerm_resource_group.projectResourceGroup.name
  location            = data.azurerm_resource_group.projectResourceGroup.location
  tags                = var.tags
  logAnalyticsName    = var.logAnalytics.name
  sku                 = var.logAnalytics.sku
  dataRetentionInDays = var.logAnalytics.dataRetentionInDays
  dailyQuotaGb        = var.logAnalytics.dailyQuotaGb
}

module "appInsightsModules" {
  source = "../../../../modules/appInsights/v1.0"

  depends_on        = [module.logAnalyticsModules]
  resourceGroupName = data.azurerm_resource_group.projectResourceGroup.name
  location          = data.azurerm_resource_group.projectResourceGroup.location
  tags              = var.tags
  appInsightsName   = var.appInsights.name
  logAnalyticsId    = module.logAnalyticsModules.logAnalyticsId
}

module "appServicePlanModules" {
  source = "../../../../modules/appServicePlan/v1.0"

  count              = var.appServicePlan.useExistingPlan ? 0 : 1
  resourceGroupName  = data.azurerm_resource_group.projectResourceGroup.name
  location           = data.azurerm_resource_group.projectResourceGroup.location
  tags               = var.tags
  appServicePlanName = var.appServicePlan.name
  sku                = var.appServicePlan.sku
  operatingSystem    = local.operatingSystem
}

module "faStorageAccountModules" {
  source = "../../../../modules/storage/v2.0"

  resourceGroupName  = data.azurerm_resource_group.projectResourceGroup.name
  location           = data.azurerm_resource_group.projectResourceGroup.location
  tags               = var.tags
  storageAccountName = var.faStorageAccount.name
}

module "dataStorageAccountModules" {
  source = "../../../../modules/storage/v2.0"

  count              = var.dataStorageAccount.enable ? 1 : 0
  resourceGroupName  = data.azurerm_resource_group.dataStorageResourceGroup[0].name
  location           = data.azurerm_resource_group.dataStorageResourceGroup[0].location
  tags               = var.tags
  storageAccountName = var.dataStorageAccount.name
}

module "keyvaultModules" {
  source = "../../../../modules/keyvault/v2.0"

  resourceGroupName         = data.azurerm_resource_group.projectResourceGroup.name
  location                  = data.azurerm_resource_group.projectResourceGroup.location
  tags                      = var.tags
  envKey                    = var.envKey
  keyvaultName              = var.keyvault.name
  keyVaultSkuName           = var.keyvault.sku
  pipelineSpEnvKey          = var.pipelineSpEnvKey
  appIdentityName           = var.keyvault.appIdentityName
  apimName                  = var.apim.name
  apimResourceGroupName     = var.apim.resourceGroupName
  githubActionsIdentityName = var.githubActionsIdentityName
}

module "staticWebAppModules" {
  source = "../../../../modules/staticWebApp/v1.0"

  count             = (var.isPrimaryRegion && var.staticWebApp.enable) ? 1 : 0
  resourceGroupName = data.azurerm_resource_group.projectResourceGroup.name
  location          = var.staticWebApp.location
  tags              = var.tags
  staticWebAppName  = var.staticWebApp.name
}
