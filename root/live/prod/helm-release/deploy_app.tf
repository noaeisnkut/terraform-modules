resource "argocd_application" "prod_app" {
  metadata {
    name      = "prod-flask-app"
    namespace = "argocd"
  }

  spec {
    project = "default"

    source {
      repo_url        = "https://github.com/noaeisnkut/second_clothes_project.git"
      target_revision = "s3"
      path            = "helm-chart"

      helm {
        value_files = ["values-prod.yaml"]
      }
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "prod"
    }

    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }
    }
  }

  depends_on = [helm_release.argocd]
}
