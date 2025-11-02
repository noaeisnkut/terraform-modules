module "argocd_prod" {
  source       = "../../../modules/argocd_project"
  project_name = "prod"
  project_yaml = "projects/prod-project.yaml"

  apps = {
    prod_app = {
      name                  = "prod-flask-app"
      repo_url              = "https://github.com/noaeisnkut/second_clothes_project.git"
      target_revision       = "main"
      path                  = "helm-chart"
      helm_value_files      = ["values-prod.yaml"]
      destination_namespace = "prod"
      destination_server    = "https://kubernetes.default.svc"
    }
  }

  depends_on = [helm_release.argocd]
}
