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

variable "appInsightsName" {
  type        = string
  description = "App Insights Name"
  validation {
    condition     = length(var.appInsightsName) <= 64
    error_message = "The length of ${var.appInsightsName} is greater than 64"
  }
  nullable = false
}

variable "logAnalyticsId" {
  type        = string
  description = "Log Analytics Id"
  nullable    = false
}
