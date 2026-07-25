terraform {
    required_providers {
        azuread = {
            source  = "hashicorp/azuread"
            version = "~> 3.9.0"
        }
    }

    backend "local" {
        path = "./../../../../temp_tf_state/tf-state"
    }
}

provider "azuread" {
  tenant_id = "85fc6366-2184-4bb8-bcb4-7cd3582e287a"
}