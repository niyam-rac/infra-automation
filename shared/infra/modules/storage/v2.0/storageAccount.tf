################################################ local variables ##################################################
locals {
}

############################################ resources to be deployed #############################################

resource "azurerm_storage_account" "storageAccount" {
  resource_group_name               = var.resourceGroupName
  location                          = var.location
  tags                              = var.tags
  name                              = var.storageAccountName
  account_kind                      = var.kind
  account_tier                      = var.sku
  account_replication_type          = var.replicationType
  public_network_access_enabled     = var.publicNetworkAccess
  min_tls_version                   = "TLS1_2"
  allow_nested_items_to_be_public   = false # Must be false for Azure policy
  shared_access_key_enabled         = false # Must be false for Azure policy
  infrastructure_encryption_enabled = true  # Must be true for Azure policy
  default_to_oauth_authentication   = true

  queue_properties {
    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 30
    }
  }
}

output "storageAccountName" {
  value       = azurerm_storage_account.storageAccount.name
  description = "Storage Account Name"
}
