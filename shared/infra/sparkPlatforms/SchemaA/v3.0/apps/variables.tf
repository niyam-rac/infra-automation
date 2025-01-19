variable "envKey" {
  type = string
  validation {
    condition     = contains(["npe", "dev", "sit", "uat", "prd"], lower(var.envKey))
    error_message = "${var.envKey} is an invalid env key"
  }
  nullable = false
}

variable "projectResourceGroupName" {
  type        = string
  description = "Project resource group name"
  nullable    = false
}

variable "tags" {
  type        = map(any)
  description = "Resource tags"
  nullable    = false
}

variable "appInsights" {
  type = object({
    name = string
  })
  description = "AppInsights"
  nullable    = false
}

variable "appServicePlan" {
  type = object({
    name              = string
    operatingSystem   = string
    useExistingPlan   = bool
    resourceGroupName = string
  })
  description = "App Service Plan"
  nullable    = false
}

variable "faStorageAccount" {
  type = object({
    name = string
  })
  description = "Storage Account for Function App"
  nullable    = false
}

variable "svcFunctionApp" {
  type = object({
    name                          = string
    stagingSlotEnabled            = bool
    stagingSlotName               = string
    operatingSystem               = string
    extensionVersion              = string
    outboundIdentityType          = string
    outboundIdentityName          = string
    outboundIdentitySubscription  = string
    outboundIdentityResourceGroup = string
    inboundAuthEnabled            = bool
    inboundAuthTenantEnvKey       = string
    inboundAuthIdentityName       = string
    inboundAuthIdentityAppId      = string
    appStackLanguage              = string
    appStackLanguageVersion       = string
    dotnetIsolatedRuntime         = bool
  })
  description = "Service Function App"

  validation {
    condition     = length(var.svcFunctionApp.name) <= 31
    error_message = "The length of ${var.svcFunctionApp.name} is greater than 31"
  }
  validation {
    condition     = contains(["None", "SystemAssigned", "UserAssigned"], var.svcFunctionApp.outboundIdentityType)
    error_message = "${var.svcFunctionApp.outboundIdentityType} is an invalid identity type. Options: None, SystemAssigned, UserAssigned"
  }
  validation {
    condition     = var.svcFunctionApp.outboundIdentityType == "UserAssigned" ? length(var.svcFunctionApp.outboundIdentityName) > 0 : true
    error_message = "Identity name must not be empty if the type is UserAssigned"
  }
}
