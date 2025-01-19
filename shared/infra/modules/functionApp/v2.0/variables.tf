variable "resourceGroupName" {
  type        = string
  description = "Project resource group name"
  nullable    = false
}

variable "location" {
  type        = string
  description = "Project resource location"
  nullable    = false
}

variable "tags" {
  type        = map(any)
  description = "Resource tags"
  nullable    = false
}

variable "functionAppName" {
  type        = string
  description = "Service App name"
  validation {
    condition     = length(var.functionAppName) <= 31
    error_message = "The length of ${var.functionAppName} is greater than 31"
  }
  nullable = false
}

variable "appServicePlanId" {
  type        = string
  description = "App Service Plan Id"
  nullable    = false
}

variable "alwaysOnEnabled" {
  type        = bool
  description = "App Service Always On Enabled"
  nullable    = false
}

variable "faStorageAccountName" {
  type        = string
  description = "Function App Storage Account Name"
  nullable    = false
}

variable "faStorageUsesManagedIdentity" {
  type        = bool
  default     = true
  description = "Whether the storage account uses managed identity, must be true for any new app due to Azure Policy"
}

variable "appInsightsConnectionString" {
  type        = string
  description = "AppInsights Connection String"
  sensitive   = true
}

variable "appInsightsKey" {
  type        = string
  description = "AppInsights Key"
  sensitive   = true
}

variable "stagingSlotEnabled" {
  type        = bool
  description = "Function App Has a Staging Slot"
  default     = true
}

variable "stagingSlotName" {
  type        = string
  description = "Function App Staging Slot Name"
  default     = "staging"
}

variable "functionsExtensionVersion" {
  type        = string
  description = "Function App Extension Version"
  default     = "~4"
}

variable "outboundIdentityType" {
  type        = string
  description = "Outbound Managed Identity Type"
  validation {
    condition     = contains(["None", "SystemAssigned", "UserAssigned"], var.outboundIdentityType)
    error_message = "${var.outboundIdentityType} is an invalid identity type"
  }
  default = "None"
}

variable "outboundIdentityName" {
  type        = string
  description = "Outbound Managed Identity Name"
  nullable    = false
}

variable "outboundIdentitySubscriptionId" {
  type        = string
  description = "The Id of the Azure Subscription where the Outbound Managed Identity on"
  nullable    = false
}

variable "outboundIdentityResourceGroup" {
  type        = string
  description = "The Resource Group Name where the Outbound Managed Identity in (For Outbound)"
  nullable    = false
}

variable "inboundAuthEnabled" {
  type        = bool
  description = "Inbound Authentication Enabled"
  default     = false
}

# The inbound identity might be from different tenant (NPE-3)
variable "inboundAuthTenantId" {
  type        = string
  description = "Inbound Auth Tenant Id"
  default     = ""
}

# If the inbound identity is from the same tenant as which the app on, then use inboundAuthIdentityName
variable "inboundAuthIdentityName" {
  type        = string
  description = "Inbound Auth Managed Identity Name"
  default     = ""
}

# If the inbound identity is from a different tenant, then use inboundAuthIdentityAppId
variable "inboundAuthIdentityAppId" {
  type        = string
  description = "Inbound Auth Managed Identity App Id"
  default     = ""
}

variable "appStackLanguage" {
  type = string
  validation {
    condition     = contains(["dotnet", "docker", "java", "node", "python", "powershell", "custom"], lower(var.appStackLanguage))
    error_message = "${var.appStackLanguage} is an invalid stack language name"
  }
  nullable = false
  default  = "dotnet"
}

// App stack language version
// For dotnet, it should be: 3.1, 6.0, 7.0
variable "appStackLanguageVersion" {
  type     = string
  nullable = true
}

variable "dotnetIsolatedRuntime" {
  type     = bool
  nullable = true
  default  = false
}
