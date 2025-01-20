# Configure the Azure provider
terraform {
  required_providers {
    azuread = {
      version = "~> 2.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.105.0"
    }
  }
  required_version = ">= 1.0.0"

  backend "azurerm" {}
}

provider "azurerm" {
  features {}

  skip_provider_registration = "true"
  storage_use_azuread        = "true"
}
