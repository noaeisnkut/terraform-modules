output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.mycluster.oidc_issuer_url
}

output "kube_host" {
  description = "The API server host URL for the AKS cluster"
  value       = azurerm_kubernetes_cluster.mycluster.kube_config.0.host
}

output "kube_client_certificate" {
  description = "Client certificate for Kubernetes provider"
  value       = azurerm_kubernetes_cluster.mycluster.kube_config.0.client_certificate
  sensitive   = true
}

output "kube_client_key" {
  description = "Client key for Kubernetes provider"
  value       = azurerm_kubernetes_cluster.mycluster.kube_config.0.client_key
  sensitive   = true
}

output "kube_cluster_ca_certificate" {
  description = "CA certificate of the AKS cluster"
  value       = azurerm_kubernetes_cluster.mycluster.kube_config.0.cluster_ca_certificate
  sensitive   = true
}