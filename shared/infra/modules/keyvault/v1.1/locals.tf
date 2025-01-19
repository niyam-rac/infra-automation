locals {
  keyvaultAccessPolicies = {
    keys = {
      FullAccess = [
        "Get",
        "List",
        "Update",
        "Create",
        "Import",
        "Delete",
        "Recover",
        "Backup",
        "Restore",
        "GetRotationPolicy",
        "SetRotationPolicy",
        "Rotate",
        "Encrypt",
        "Decrypt",
        "UnwrapKey",
        "WrapKey",
        "Verify",
        "Sign",
        "Purge",
        "Release"
      ]
      ReadWrite = [
        "Get",
        "List",
        "Update",
        "Create",
        "Import",
        "Delete"
      ]
      ReadOnly = [
        "Get",
        "List"
      ]
    }
    certificates = {
      FullAccess = [
        "Get",
        "List",
        "Update",
        "Create",
        "Import",
        "Delete",
        "Recover",
        "Backup",
        "Restore",
        "ManageContacts",
        "ManageIssuers",
        "GetIssuers",
        "ListIssuers",
        "SetIssuers",
        "DeleteIssuers",
        "Purge"
      ]
      ReadWrite = [
        "Get",
        "List",
        "Update",
        "Create",
        "Import",
        "Delete"
      ]
      ReadOnly = [
        "Get",
        "List"
      ]
    }
    secrets = {
      FullAccess = [
        "Get",
        "List",
        "Set",
        "Delete",
        "Recover",
        "Backup",
        "Restore",
        "Purge"
      ]
      ReadWrite = [
        "Get",
        "List",
        "Set",
        "Delete"
      ]
      ReadOnly = [
        "Get",
        "List"
      ]
    }
  }
}
