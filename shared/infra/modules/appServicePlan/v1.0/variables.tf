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

variable "appServicePlanName" {
  type        = string
  description = "App Service Plan Name"
  validation {
    condition     = length(var.appServicePlanName) <= 64
    error_message = "The length of ${var.appServicePlanName} is greater than 64"
  }
  nullable = false
}

// [B1 B2 B3 S1 S2 S3 P1v2 P2v2 P3v2 P0v3 P1v3 P2v3 P3v3 P1mv3 P2mv3 P3mv3 P4mv3 P5mv3 
// Y1 EP1 EP2 EP3 F1 I1 I2 I3 I1v2 I2v2 I3v2 I4v2 I5v2 I6v2 D1 SHARED WS1 WS2 WS3]
variable "sku" {
  type        = string
  description = "App Service Plan SKU"
  default     = "Y1"
}

variable "operatingSystem" {
  type        = string
  description = "App Service Plan Operating System"
  default     = "Linux"
  validation {
    condition     = contains(["Linux", "Windows"], var.operatingSystem)
    error_message = "${var.operatingSystem} is an invalid App Service Plan Operating System"
  }
}
