data "kubernetes_resource" "gateway_status" {
  api_version = "gateway.networking.k8s.io/v1"
  kind        = "Gateway"
  metadata {
    name      = var.gateway_name
    namespace = var.namespace
  }
  depends_on = [helm_release.alb_controller]
}
