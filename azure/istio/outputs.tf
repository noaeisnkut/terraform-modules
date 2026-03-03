output "istio_version" {
  value = var.istio_release_version
}

output "external_gateway_ip" {
  value       = var.istio_enable_external_gateway ? data.kubernetes_service_v1.external_gw[0].status[0].load_balancer[0].ingress[0].ip : null
  description = "Public IP of the external Istio Gateway"
}