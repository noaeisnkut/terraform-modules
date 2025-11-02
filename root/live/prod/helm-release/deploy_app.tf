resource "helm_release" "prod_flask_app" {
  name       = "prod-flask-app"
  namespace  = "prod"
  repository = "https://github.com/noaeisnkut/second_clothes_project.git"
  chart      = "helm-chart"  
  values     = ["https://raw.githubusercontent.com/noaeisnkut/second_clothes_project/s3/helm-chart/values-prod.yaml"]

  depends_on = [helm_release.argocd]
}
