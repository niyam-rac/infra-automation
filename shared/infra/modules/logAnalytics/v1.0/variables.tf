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

variable "logAnalyticsName" {
  type        = string
  description = "Log Analytics Workspace Name"
  validation {
    condition     = length(var.logAnalyticsName) <= 64
    error_message = "The length of ${var.logAnalyticsName} is greater than 64"
  }
  nullable = false
}

variable "sku" {
  type        = string
  description = "Log Analytics Workspace SKU"
  default     = "PerGB2018"
  // To do: add validation
}

variable "dataRetentionInDays" {
  type        = number
  description = "Log Analytics Workspace Data Retention in Days"
  default     = 30
}

variable "dailyQuotaGb" {
  type        = number
  description = "Log Analytics Workspace Daily Quota in Gb"
  default     = -1
}
