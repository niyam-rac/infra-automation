################################################ local variables ##################################################
locals {
}

############################################ resources to be deployed #############################################

resource "azurerm_storage_account" "storageAccount" {
  resource_group_name               = var.resourceGroupName
  location                          = var.location
  min_tls_version                   = "TLS1_2"
  tags                              = var.tags
  name                              = var.storageAccountName
  account_kind                      = var.kind
  account_tier                      = var.sku
  account_replication_type          = var.replicationType
  allow_nested_items_to_be_public   = false
  public_network_access_enabled     = var.publicNetworkAccess
  infrastructure_encryption_enabled = var.infrastructureEncryptionEnabled

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
