resource "helm_release" "dev_flask_app" {
  name       = "dev-flask-app"
  namespace  = "dev"  
  chart      = "./helm-chart" 
  values     = ["https://raw.githubusercontent.com/noaeisnkut/second_clothes_project/s3/helm-chart/values-dev.yaml"]

  depends_on = [helm_release.argocd]
}

resource "helm_release" "staging_flask_app" {
  name       = "staging-flask-app"
  namespace  = "staging"
  chart      = "./helm-chart"
  values     = ["https://raw.githubusercontent.com/noaeisnkut/second_clothes_project/s3/helm-chart/values-staging.yaml"]

  depends_on = [helm_release.argocd]
}
