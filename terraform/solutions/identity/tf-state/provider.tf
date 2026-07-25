terraform {
    required_providers {
        azuread = {
            source  = "hashicorp/azuread"
            version = "~> 3.9.0"
        }
    }

    backend "azurerm" {
        resource_group_name  = "rg-tf-state-aue"
        storage_account_name = "stspdevtfstate"
        container_name       = "sub-management"
        
        # Virtual path prefix creates the folder structure in the UI
        key                  = "identity/tf-state.tfstate" 
        
        use_azuread_auth     = true
    }
}

provider "azuread" {
  tenant_id = "85fc6366-2184-4bb8-bcb4-7cd3582e287a"
}