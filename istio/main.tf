resource "helm_release" "istio_base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = var.istio_release_version
  namespace        = var.istio_release_namespace
  create_namespace = true
}

resource "helm_release" "istio_discovery" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = var.istio_release_version
  namespace  = var.istio_release_namespace
  set = [
    {
      name  = "meshConfig.accessLogFile"
      value = "/dev/stdout"
    },
    {
      name  = "profile"
      value = "minimal"
    }
  ]

  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istio_gateway_external" {
  count      = var.istio_enable_external_gateway ? 1 : 0
  name       = "istio-ingressgateway-external"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = var.istio_release_version
  namespace  = var.istio_release_namespace

  values = [
    yamlencode({
      service = {
        type = "ClusterIP" 
      }
    })
  ]

  depends_on = [helm_release.istio_discovery]
}