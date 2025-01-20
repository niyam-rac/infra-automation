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

  authority                    = local.envVars.authority
  identityEnvKey               = (var.envKey == "prd") ? "prd" : "npe"
  inboundAuthTenantEnvKey      = (var.envKey == "prd") ? "prd" : "npe"
  svcAppStagingSlotName        = local.envVars.svcAppStagingSlotName
  svcAppFunctionExtVersion     = local.envVars.svcAppFunctionExtVersion
  appStackLanguage             = "dotnet"
  appStackLanguageVersion      = local.envVars.appStackLanguageVersion // Options: 3.1, 6.0, 7.0
  dotnetIsolatedRuntime        = local.envVars.dotnetIsolatedRuntime   // Run dotnet on Isolated mode
  outboundIdentitySubscription = (var.envKey == "prd") ? "PRD" : "NPE" // Options: NPE or NPE3 (for NPE), PRD (for PROD)
  managedIdentityResourceGroup = upper("${local.authority}-DCC-ARG-${local.identityEnvKey}-310")

  ########################################### project config local variables ########################################

  svcAppStagingSlotEnabled        = local.envVars.svcAppStagingSlotEnabled
  useExistingAppServicePlan       = local.envVars.useExistingAppServicePlan
  projectResourceGroupName        = upper("${local.authority}-${var.regionKey}-ARG-${var.envKey}-${local.envVars.resourceGroupNameSuffix}")
  svcAppOperatingSystem           = local.envVars.svcAppOperatingSystem
  appServicePlanName              = local.useExistingAppServicePlan ? lower("${local.authority}-${var.regionKey}-asp-${var.envKey}-${local.envVars.appServicePlanNameSuffix}") : lower("${local.authority}-${var.regionKey}-asp-${var.envKey}-${local.envVars.projectKey}")
  appServicePlanResourceGroupName = local.useExistingAppServicePlan ? upper("${local.authority}-${var.regionKey}-ARG-${var.envKey}-${local.envVars.appServicePlanRgNameSuffix}") : ""
  appInsightsName                 = lower("${local.authority}-${var.regionKey}-ain-${var.envKey}-${local.envVars.projectKey}")
  faStorageAccountName            = lower("${local.authority}${var.regionKey}sta${var.envKey}${local.envVars.svcAppStorageNameSuffix}")
  functionAppName                 = lower("${local.authority}${var.regionKey}fa${var.envKey}${local.envVars.svcAppNameSuffix}")
  managedIdentityName             = lower("${local.authority}-umi-${local.identityEnvKey}-${local.envVars.managedIdentityNameSuffix}")
  # Please be aware of if the svcAppPublicNetworkAccessEnabled = false, it means all the traffic will go through private vnet.
  # Please make sure the service app has private vnet integration in place.
  svcAppPublicNetworkAccessEnabled = true
  svcAppIpRestrictionsMerged       = (var.envKey == "uat" || var.envKey == "prd") ? concat(local.envVars.svcAppIpRestrictionsAPIMShared, local.envVars.svcAppIpRestrictions) : concat(local.envVars.svcAppIpRestrictionsInternalShared, local.envVars.svcAppIpRestrictionsAPIMShared, local.envVars.svcAppIpRestrictions)
  svcAppIpRestrictions             = local.envVars.svcAppIpRestrictionEnabled ? local.svcAppIpRestrictionsMerged : []
}
