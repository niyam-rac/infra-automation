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

variable "isPrimaryRegion" {
  type        = bool
  description = "Is Primary Region"
  default     = false
}

variable "pipelineSpEnvKey" {
  type        = string
  description = "Pipeline service principals AAD group env key"
  validation {
    condition     = contains(["npe", "prd"], var.pipelineSpEnvKey)
    error_message = "${var.pipelineSpEnvKey} is an invalid environment key"
  }
}

variable "tags" {
  type        = map(any)
  description = "Resource tags"
  nullable    = false
}

variable "logAnalytics" {
  type = object({
    name                = string
    sku                 = string
    dataRetentionInDays = number
    dailyQuotaGb        = number
  })
  description = "Log Analytics"
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
    sku               = string
    operatingSystem   = string
    useExistingPlan   = bool
    resourceGroupName = string
  })
  description = "App Service Plan"
  nullable    = false
}

variable "keyvault" {
  type = object({
    name            = string
    sku             = string
    appIdentityName = string
  })
  description = "Key Vault"
  nullable    = false
}

variable "faStorageAccount" {
  type = object({
    name                            = string
    infrastructureEncryptionEnabled = optional(bool)
  })
  description = "Storage Account for Function App"
  nullable    = false
  validation {
    condition     = length(var.faStorageAccount.name) <= 24
    error_message = "The length of ${var.faStorageAccount.name} is greater than 24"
  }
}

variable "dataStorageAccount" {
  type = object({
    name                            = string
    enable                          = bool
    resourceGroupName               = string
    infrastructureEncryptionEnabled = optional(bool)
  })
  description = "Storage Account for data"
  nullable    = true
  validation {
    condition     = length(var.dataStorageAccount.name) <= 24
    error_message = "The length of ${var.dataStorageAccount.name} is greater than 24"
  }
  default = {
    name              = ""
    enable            = false
    resourceGroupName = ""
  }
}

variable "staticWebApp" {
  type = object({
    name     = string
    location = string
    enable   = bool
  })
  description = "Static Web App"
}
