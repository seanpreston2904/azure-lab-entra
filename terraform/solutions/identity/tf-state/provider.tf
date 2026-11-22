terraform {
    required_providers {
        azuread = {
            source  = "hashicorp/azuread"
            version = "~> 3.9.0"
        }
    }

    # Settings are supplied by the reusable workflows via -backend-config
    backend "azurerm" {}
}

provider "azuread" {
  tenant_id = "85fc6366-2184-4bb8-bcb4-7cd3582e287a"
}