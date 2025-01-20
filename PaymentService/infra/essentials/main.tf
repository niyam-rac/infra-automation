################################################ existing resources ####################################################



##################################### platform module resources to be deployed ####################################

module "sparkPlatformEssentials" {
  source                    = "../../../../shared/infra/sparkPlatforms/SchemaA/v4.2/essentials"
  envKey                    = var.envKey
  projectResourceGroupName  = local.projectResourceGroupName
  isPrimaryRegion           = local.isPrimaryRegion
  pipelineSpEnvKey          = local.pipelineSpEnvKey
  tags                      = local.resourceTags
  githubActionsIdentityName = local.githubActionsIdentityName
  logAnalytics = {
    name                = local.logAnalyticsWorkspaceName
    sku                 = local.logAnalyticsSku
    dataRetentionInDays = local.logAnalyticsDataRetentionInDays
    dailyQuotaGb        = local.logAnalyticsDailyQuotaGb
  }
  appInsights = {
    name = local.appInsightsName
  }
  appServicePlan = {
    name              = local.appServicePlanName
    sku               = local.envVars.appServicePlanSku
    operatingSystem   = local.svcAppOperatingSystem
    useExistingPlan   = local.useExistingAppServicePlan
    resourceGroupName = local.appServicePlanResourceGroupName
  }
  keyvault = {
    name            = local.keyvaultName
    sku             = local.keyVaultSku
    appIdentityName = local.managedIdentityName
  }
  faStorageAccount = {
    name = local.faStorageAccountName
  }
  staticWebApp = {
    name     = local.staticWebAppName
    location = local.staticWebAppLocation
    enable   = local.enableStaticWebApp
  }

  # If the DataStorageAccount is not required, then these variables and the references can be deleted
  dataStorageAccount = {
    name                            = local.dataStorageAccountName
    enable                          = local.enableDataStorageAccount
    resourceGroupName               = local.dataStorageResourceGroupName
    hierarchicalNamespaceEnabled    = local.dataStorageAccountHierarchicalNamespaceEnabled
    sharedAccessKeyEnabled          = local.dataStorageSharedAccessKeyEnabled
  }
  apim = {
    name              = local.apimName
    resourceGroupName = local.apimResourceGroupName
  }
}
