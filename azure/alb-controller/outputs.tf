output "identity_client_id" {
  value = azurerm_user_assigned_identity.alb_controller.client_id
}

output "identity_principal_id" {
  value = azurerm_user_assigned_identity.alb_controller.principal_id
}

output "helm_release_status" {
  value = helm_release.alb_controller.status
}
output "alb_public_ip" {
  value = data.kubernetes_resource.gateway_status.object.status.addresses[0].value
}
output "http_routes" {
  value = {
    argocd = kubernetes_manifest.http_route_argocd.metadata[0].name
    flask  = kubernetes_manifest.http_route_flask.metadata[0].name
  }
}