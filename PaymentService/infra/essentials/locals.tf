locals {
  ############################################### common local variables ############################################

  sharedInfraJsonData = jsondecode(file("../../../../shared/infra/sparkPlatforms/SchemaA/v4.1/configs/infra.config.json"))
  infraJsonData       = jsondecode(file("../configs/infra.config.json"))
  envVars             = merge(local.sharedInfraJsonData.common, local.sharedInfraJsonData[var.envKey], local.infraJsonData.common, local.infraJsonData[var.envKey])
  releaseTags = {
    ReleaseVersion = var.releaseVersion
    PipelineId     = var.pipelineId
  }
  resourceTags = merge(local.envVars.resourceTagsShared, local.envVars.resourceTagsProject, local.envVars.resourceTagsEnv, local.releaseTags)

  authority                       = local.envVars.authority
  identityEnvKey                  = (var.envKey == "prd") ? "prd" : "npe" // Env Key for the managed identity
  pipelineSpEnvKey                = (var.envKey == "prd") ? "prd" : "npe" // Env Key for the pipeline service principals AAD group
  keyVaultSku                     = "standard"
  logAnalyticsSku                 = "PerGB2018"
  logAnalyticsDailyQuotaGb        = -1
  logAnalyticsDataRetentionInDays = (var.envKey == "prd") ? 90 : ((var.envKey == "uat") ? 60 : 30)
  staticWebAppSku                 = "standard"
  staticWebAppLocation            = "Central US"
  apimName                        = upper("${local.authority}-${(var.envKey == "sit") ? "DCD" : "DCC"}-APM-${var.envKey}-001")
  apimResourceGroupName           = upper("${local.authority}-${(var.envKey == "sit") ? "DCD" : "DCC"}-ARG-${var.envKey}-015")

  ########################################### project config local variables ########################################

  isPrimaryRegion                 = var.regionKey == "dcc" || var.envKey == "sit" // For a few old services, the primary region might be dcc in SIT.
  useExistingAppServicePlan       = local.envVars.useExistingAppServicePlan
  enableStaticWebApp              = local.envVars.enableStaticWebApp
  projectResourceGroupName        = upper("${local.authority}-${var.regionKey}-ARG-${var.envKey}-${local.envVars.resourceGroupNameSuffix}")
  svcAppOperatingSystem           = local.envVars.svcAppOperatingSystem
  appServicePlanName              = local.useExistingAppServicePlan ? lower("${local.authority}-${var.regionKey}-asp-${var.envKey}-${local.envVars.appServicePlanNameSuffix}") : lower("${local.authority}-${var.regionKey}-asp-${var.envKey}-${local.envVars.projectKey}")
  appServicePlanResourceGroupName = local.useExistingAppServicePlan ? upper("${local.authority}-${var.regionKey}-ARG-${var.envKey}-${local.envVars.appServicePlanRgNameSuffix}") : ""
  logAnalyticsWorkspaceName       = lower("${local.authority}-${var.regionKey}-oms-${var.envKey}-${local.envVars.projectKey}")
  appInsightsName                 = lower("${local.authority}-${var.regionKey}-ain-${var.envKey}-${local.envVars.projectKey}")
  keyvaultName                    = lower("${local.authority}-${var.regionKey}-key-${var.envKey}-${local.envVars.keyvaultNameSuffix}")
  faStorageAccountName            = lower("${local.authority}${var.regionKey}sta${var.envKey}${local.envVars.svcAppStorageNameSuffix}")
  staticWebAppName                = local.enableStaticWebApp ? lower("${local.authority}-${var.regionKey}-swa-${var.envKey}-${local.envVars.projectKey}") : ""
  managedIdentityName             = lower("${local.authority}-umi-${local.identityEnvKey}-${local.envVars.managedIdentityNameSuffix}")
  githubActionsIdentityName       = lower("github-actions-${local.envVars.bffRepositoryName}-${var.envKey}")

  # If the DataStorageAccount is not required, then these variables and the references can be deleted
  enableDataStorageAccount                       = true && local.isPrimaryRegion
  dataStorageAccountName                         = local.enableDataStorageAccount ? lower("${local.authority}${var.regionKey}sta${var.envKey}${local.envVars.dataStorageNameSuffix}") : ""
  dataStorageResourceGroupName                   = local.enableDataStorageAccount ? upper("${local.authority}-${var.regionKey}-ARG-${var.envKey}-${local.envVars.dataStorageRGNameSuffix}") : ""
  dataStorageAccountHierarchicalNamespaceEnabled = local.enableDataStorageAccount ? local.envVars.dataStorageAccountHierarchicalNamespaceEnabled : false
  dataStorageSharedAccessKeyEnabled              = true # TODO - Change to false after CCI safely deployed to PRD
  # Variable unique to CCI
}
