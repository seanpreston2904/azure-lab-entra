#
# Management App Registration
#
resource "azuread_application_registration" "sp_id_tf_state_management_app_reg" {
    display_name    = "sp-id-tf-state-management"
    description     = "Used to manage Terraform state for management landing zone."
}

#
# Management (Identity) App Registration Federated Identity Credentials
#
resource "azuread_application_federated_identity_credential" "sp_id_tf_state_plan_credential" {
    application_id  = azuread_application_registration.sp_id_tf_state_management_app_reg.id
    display_name    = "sp-id-tf-state-plan-management"
    description     = "Plans from azure-lab-entra diff branch."
    audiences       = ["api://AzureADTokenExchange"]
    issuer          = "https://token.actions.githubusercontent.com"
    subject         = "repo:seanpreston2904@38393064/azure-lab-entra@1305699783:environment:terraform-plan"
}

resource "azuread_application_federated_identity_credential" "sp_id_tf_state_apply_credential" {
    application_id  = azuread_application_registration.sp_id_tf_state_management_app_reg.id
    display_name    = "sp-id-tf-state-apply-management"
    description     = "Applies from azure-lab-entra main branch."
    audiences       = ["api://AzureADTokenExchange"]
    issuer          = "https://token.actions.githubusercontent.com"
    subject         = "repo:seanpreston2904@38393064/azure-lab-entra@1305699783:environment:terraform-apply"
}

#
# Management (Identity) App Registration Federated Identity Credentials
#
resource "azuread_application_federated_identity_credential" "sp_id_tf_state_plan_credential" {
    application_id  = azuread_application_registration.sp_id_tf_state_management_app_reg.id
    display_name    = "sp-id-tf-state-plan-connectivity"
    description     = "Plans from azure-lab-entra diff branch."
    audiences       = ["api://AzureADTokenExchange"]
    issuer          = "https://token.actions.githubusercontent.com"
    subject         = "repo:seanpreston2904@38393064/azure-lab-connectivity@1467320075:environment:terraform-plan"
}

resource "azuread_application_federated_identity_credential" "sp_id_tf_state_apply_credential" {
    application_id  = azuread_application_registration.sp_id_tf_state_management_app_reg.id
    display_name    = "sp-id-tf-state-apply-connectivity"
    description     = "Applies from azure-lab-entra main branch."
    audiences       = ["api://AzureADTokenExchange"]
    issuer          = "https://token.actions.githubusercontent.com"
    subject         = "repo:seanpreston2904@38393064/azure-lab-connectivity@1467320075:environment:terraform-apply"
}

resource "azuread_service_principal" "sp_id_tf_state_principal" {
    client_id = azuread_application_registration.sp_id_tf_state_management_app_reg.client_id
}