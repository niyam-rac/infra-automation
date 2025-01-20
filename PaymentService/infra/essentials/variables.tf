variable "envKey" {
  type = string
  validation {
    condition     = contains(["npe", "dev", "sit", "uat", "prd"], lower(var.envKey))
    error_message = "${var.envKey} is an invalid env key"
  }
}

variable "regionKey" {
  type = string
  validation {
    condition     = contains(["dcc", "dcd"], var.regionKey)
    error_message = "${var.regionKey} is an invalid region key"
  }
}

variable "releaseVersion" {
  type        = string
  description = "Deployment version"
  default     = "0.0.0"
}

variable "pipelineId" {
  type        = string
  description = "Deployment pipeline Id"
  default     = "0"
}
