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

variable "storageAccountName" {
  type        = string
  description = "Storage Account Name"
  validation {
    condition     = length(var.storageAccountName) <= 24
    error_message = "The length of ${var.storageAccountName} is greater than 24"
  }
  nullable = false
}

variable "sku" {
  type        = string
  description = "Storage Account SKU"
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.sku)
    error_message = "${var.sku} is an invalid Storage Account SKU"
  }
}

variable "kind" {
  type        = string
  description = "Storage Account Kind"
  default     = "StorageV2"
}

variable "replicationType" {
  type        = string
  description = "Storage Account Replication Type"
  default     = "LRS"
}

variable "publicNetworkAccess" {
  type        = string
  description = "Public Network Access Enabled"
  default     = true
}

variable "infrastructureEncryptionEnabled" {
  type        = bool
  default     = true
  description = "Infrastructure Encryption Enabled, must be true for any new app due to Azure Policy"
}
