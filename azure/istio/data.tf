data "kubernetes_service_v1" "external_gw" {
  count = var.istio_enable_external_gateway ? 1 : 0

  metadata {
    name      = "istio-ingressgateway-external"
    namespace = var.istio_release_namespace
  }

  depends_on = [helm_release.istio_gateway_external[0]]
}