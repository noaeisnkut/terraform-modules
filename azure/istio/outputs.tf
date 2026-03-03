output "istio_version" {
  value = var.istio_release_version
}
output "istio_namespace" {
  description = "Namespace where Istio ingress gateway service is deployed"
  value       = var.istio_release_namespace
}

output "istio_ingress_service_name" {
  description = "Service name of the Istio ingress gateway to be used by ALB"
  value       = "istio-ingressgateway-external"  # the ClusterIP service you created
}