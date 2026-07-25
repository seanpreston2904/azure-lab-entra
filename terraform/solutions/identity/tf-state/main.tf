resource "azuread_application_registration" "sp_id_tf_state_app_reg" {
    display_name    = "sp-id-tf-state-management"
    description     = "Used to manage Terraform state for management landing zone."
}

resource "azuread_application_federated_identity_credential" "sp_id_tf_state_credential" {
    application_id  = azuread_application_registration.sp_id_tf_state_app_reg.id
    display_name    = "github-actions"
    description     = "Deploys from azure-lab-entra main branch"
    audiences       = ["api://AzureADTokenExchange"]
    issuer          = "https://token.actions.githubusercontent.com"
    subject         = "repo:seanpreston2904@38393064/azure-lab-entra@1305699783:environment:terraform-plan"
}

resource "azuread_service_principal" "sp_id_tf_state_principal" {
    client_id = azuread_application_registration.sp_id_tf_state_app_reg.client_id
}