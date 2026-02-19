output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.mycluster.oidc_issuer_url
}

output "client_key" {
  value     = azurerm_kubernetes_cluster.mycluster.kube_config.0.client_key
  sensitive = true
}