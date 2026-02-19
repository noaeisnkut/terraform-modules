data "kubernetes_service" "external_gw" {
  count = var.istio_enable_external_gateway ? 1 : 0
  metadata {
    name      = "istio-ingressgateway-public"
    namespace = var.istio_release_namespace
  }
  depends_on = [helm_release.istio_gateway_external]
}

output "ingress_public_ip" {
  description = "The Public IP of the Istio Ingress Gateway"
  value       = var.istio_enable_external_gateway ? data.kubernetes_service.external_gw[0].status[0].load_balancer[0].ingress[0].ip : null
}

output "istio_version" {
  value = var.istio_release_version
}