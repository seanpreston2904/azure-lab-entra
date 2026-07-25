resource "azuread_application_registration" "sp_id_tf_state" {
    display_name    = "sp-id-tf-state-management"
    description     = "Used to manage Terraform state for management landing zone."
}

resource "azuread_application_federated_identity_credential" "sp_id_tf_state_credential" {
    application_id  = azuread_application_registration.sp_id_tf_state.application_id
    display_name    = "github-actions"
    description     = "Deploys from azure-lab-entra main branch"
    audiences       = ["api://AzureADTokenExchange"]
    issuer          = "https://token.actions.githubusercontent.com"
    subject         = "repo:seanpreston2904/azure-lab-entra:ref:refs/heads/master"
}