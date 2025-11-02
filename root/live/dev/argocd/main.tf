module "argocd_dev" {
  source       = "../../../modules/argocd_project"
  project_name = "dev"
  project_yaml = "projects/dev-project.yaml"

  apps = {
    dev_app = {
      name                  = "dev-flask-app"
      repo_url              = "https://github.com/noaeisnkut/second_clothes_project.git"
      target_revision       = "s3"
      path                  = "helm-chart"
      helm_value_files      = ["values-dev.yaml"]
      destination_namespace = "dev"
      destination_server    = "https://kubernetes.default.svc"
    }
    staging_app = {
      name                  = "staging-flask-app"
      repo_url              = "https://github.com/noaeisnkut/second_clothes_project.git"
      target_revision       = "s3"
      path                  = "helm-chart"
      helm_value_files      = ["values-staging.yaml"]
      destination_namespace = "staging"
      destination_server    = "https://kubernetes.default.svc"
    }
  }

  depends_on = [helm_release.argocd]
}
