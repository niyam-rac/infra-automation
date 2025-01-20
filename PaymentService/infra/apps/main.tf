################################################ existing resources ####################################################



##################################### platform module resources to be deployed ####################################

module "sparkPlatformApps" {
  source                   = "../../shared/infra/sparkPlatforms/SchemaA/v4.2/apps"
  envKey                   = var.envKey
  projectResourceGroupName = local.projectResourceGroupName
  tags                     = local.resourceTags
  appInsights = {
    name = local.appInsightsName
  }
  appServicePlan = {
    name              = local.appServicePlanName
    operatingSystem   = local.svcAppOperatingSystem
    useExistingPlan   = local.useExistingAppServicePlan
    resourceGroupName = local.appServicePlanResourceGroupName
  }
  faStorageAccount = {
    name = local.faStorageAccountName
  }
  svcFunctionApp = {
    name                          = local.functionAppName
    operatingSystem               = local.svcAppOperatingSystem
    extensionVersion              = local.svcAppFunctionExtVersion
    stagingSlotName               = local.svcAppStagingSlotName
    stagingSlotEnabled            = local.svcAppStagingSlotEnabled
    outboundIdentityType          = local.envVars.svcAppOutboundIdentityType
    outboundIdentityName          = local.managedIdentityName
    outboundIdentitySubscription  = local.outboundIdentitySubscription
    outboundIdentityResourceGroup = local.managedIdentityResourceGroup
    inboundAuthEnabled            = local.envVars.svcAppInboundAuthEnabled
    inboundAuthTenantEnvKey       = local.inboundAuthTenantEnvKey
    inboundAuthIdentityName       = local.managedIdentityName
    inboundAuthIdentityAppId      = "" // Only when the inbound identity is from a different tenant, otherwise, set up an empty string
    appStackLanguage              = local.appStackLanguage
    appStackLanguageVersion       = local.appStackLanguageVersion
    dotnetIsolatedRuntime         = local.dotnetIsolatedRuntime
    publicNetworkAccessEnabled    = local.svcAppPublicNetworkAccessEnabled
    ipRestrictions                = local.svcAppIpRestrictions
  }
}
