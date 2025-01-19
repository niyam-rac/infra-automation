########################################### local variables #######################################################
locals {
  tenantIdPRD                    = "6f0e7657-1985-4cc9-9a41-d6ebe342d2e4"
  tenantIdNPE                    = "2f83fb84-24df-45d5-9137-da51abb46251"
  subscriptionIdNPE              = "0a665cc4-710c-470e-93d5-ee839efb27be"
  subscriptionIdNPE2             = "be5438b0-b55b-4b1b-b836-aa9878adc040"
  subscriptionIdNPE3             = "f1addffb-2fc0-4b2a-a5f3-a4a1038afa33"
  subscriptionIdPRD              = "0efb7770-c4e6-4d01-9452-fe1b32252194"
  outboundIdentitySubscriptionId = (var.envKey == "prd") ? local.subscriptionIdPRD : ((var.svcFunctionApp.outboundIdentitySubscription == "NPE3") ? local.subscriptionIdNPE3 : local.subscriptionIdNPE)
  operatingSystem                = (lower(var.appServicePlan.operatingSystem) == "windows") ? "Windows" : "Linux"
  appServicePlanId               = var.appServicePlan.useExistingPlan ? data.azurerm_service_plan.appServicePlanExisting[0].id : data.azurerm_service_plan.appServicePlanProject[0].id
  appServicePlanSku              = var.appServicePlan.useExistingPlan ? data.azurerm_service_plan.appServicePlanExisting[0].sku_name : data.azurerm_service_plan.appServicePlanProject[0].sku_name
  svcFunctionAppAlwaysOnEnabled  = contains(["B", "S", "P", "E", "I"], substr(local.appServicePlanSku, 0, 1))
  inboundAuthTenantId            = var.svcFunctionApp.inboundAuthTenantEnvKey == "prd" ? local.tenantIdPRD : local.tenantIdNPE
}

########################################### existing resources ####################################################

data "azurerm_resource_group" "projectResourceGroup" {
  name = var.projectResourceGroupName
}

# The app service plan that had already been created for sharing
data "azurerm_service_plan" "appServicePlanExisting" {
  count               = var.appServicePlan.useExistingPlan ? 1 : 0
  name                = var.appServicePlan.name
  resource_group_name = var.appServicePlan.resourceGroupName
}

# The app service plan that is created for this project
data "azurerm_service_plan" "appServicePlanProject" {
  count               = var.appServicePlan.useExistingPlan ? 0 : 1
  name                = var.appServicePlan.name
  resource_group_name = var.projectResourceGroupName
}

data "azurerm_application_insights" "appInsights" {
  name                = var.appInsights.name
  resource_group_name = var.projectResourceGroupName
}

data "azurerm_storage_account" "faStorageAccount" {
  name                = var.faStorageAccount.name
  resource_group_name = var.projectResourceGroupName
}

######################################## module resources to be deployed ##########################################

module "functionAppModules" {
  source = "../../../../modules/functionApp/v2.1"

  resourceGroupName              = data.azurerm_resource_group.projectResourceGroup.name
  location                       = data.azurerm_resource_group.projectResourceGroup.location
  tags                           = var.tags
  functionAppName                = var.svcFunctionApp.name
  stagingSlotEnabled             = var.svcFunctionApp.stagingSlotEnabled
  stagingSlotName                = var.svcFunctionApp.stagingSlotName
  functionsExtensionVersion      = var.svcFunctionApp.extensionVersion
  alwaysOnEnabled                = local.svcFunctionAppAlwaysOnEnabled
  outboundIdentityType           = var.svcFunctionApp.outboundIdentityType
  outboundIdentityName           = var.svcFunctionApp.outboundIdentityName
  outboundIdentitySubscriptionId = local.outboundIdentitySubscriptionId
  outboundIdentityResourceGroup  = var.svcFunctionApp.outboundIdentityResourceGroup
  inboundAuthEnabled             = var.svcFunctionApp.inboundAuthEnabled
  inboundAuthTenantId            = local.inboundAuthTenantId
  inboundAuthIdentityName        = var.svcFunctionApp.inboundAuthIdentityName
  inboundAuthIdentityAppId       = var.svcFunctionApp.inboundAuthIdentityAppId
  faStorageAccountName           = data.azurerm_storage_account.faStorageAccount.name
  appInsightsConnectionString    = data.azurerm_application_insights.appInsights.connection_string
  appInsightsKey                 = data.azurerm_application_insights.appInsights.instrumentation_key
  appServicePlanId               = local.appServicePlanId
  appStackLanguage               = var.svcFunctionApp.appStackLanguage
  appStackLanguageVersion        = var.svcFunctionApp.appStackLanguageVersion
  dotnetIsolatedRuntime          = var.svcFunctionApp.dotnetIsolatedRuntime
  publicNetworkAccessEnabled     = var.svcFunctionApp.publicNetworkAccessEnabled
  ipRestrictions                 = var.svcFunctionApp.ipRestrictions
}
