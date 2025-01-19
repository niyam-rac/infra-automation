variable "envKey" {
  type = string
  validation {
    condition     = contains(["npe", "dev", "sit", "uat", "prd"], lower(var.envKey))
    error_message = "${var.envKey} is an invalid env key"
  }
}

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

variable "keyvaultName" {
  type        = string
  description = "Keyvault name"
  nullable    = false
}

variable "keyVaultSkuName" {
  type        = string
  description = "KeyVault Sku name"
  nullable    = false
}

variable "pipelineSpEnvKey" {
  type        = string
  description = "Pipeline service principals AAD group env key"
  validation {
    condition     = contains(["npe", "prd"], var.pipelineSpEnvKey)
    error_message = "${var.pipelineSpEnvKey} is an invalid environment key"
  }
}

variable "appIdentityName" {
  type        = string
  description = "User Managed Identity Name"
  nullable    = false
}

variable "apimName" {
  type        = string
  description = "API Management Name"
}

variable "apimResourceGroupName" {
  type        = string
  description = "API Management Resoure Group Name"
}
