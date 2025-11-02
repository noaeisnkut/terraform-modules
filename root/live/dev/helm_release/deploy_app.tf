resource "kubernetes_namespace" "dev_ns" {
  metadata {
    name = "dev"
  }
}

resource "helm_release" "dev_flask_app" {
  name       = "dev-flask-app"
  namespace  = kubernetes_namespace.dev_ns.metadata[0].name
  repository = "https://github.com/noaeisnkut/second_clothes_project.git"
  chart      = "helm-chart"  
  values     = ["https://raw.githubusercontent.com/noaeisnkut/second_clothes_project/s3/helm-chart/values-dev.yaml"]

  depends_on = [helm_release.argocd]
}


resource "kubernetes_namespace" "staging_ns" {
  metadata {
    name = "staging"
  }
}

resource "helm_release" "staging_flask_app" {
  name       = "staging-flask-app"
  namespace  = kubernetes_namespace.staging_ns.metadata[0].name
  repository = "https://github.com/noaeisnkut/second_clothes_project.git"
  chart      = "helm-chart"
  values     = ["https://raw.githubusercontent.com/noaeisnkut/second_clothes_project/s3/helm-chart/values-staging.yaml"]

  depends_on = [helm_release.argocd]
}