resource "argocd_application" "dev_app" {
  metadata {
    name      = "dev-flask-app"
    namespace = "argocd"
  }

  spec {
    project = "default"

    source {
      repo_url        = "https://github.com/noaeisnkut/second_clothes_project.git"
      target_revision = "s3"
      path            = "helm-chart"

      helm {
        value_files = ["values-dev.yaml"]
      }
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "dev"
    }

    sync_policy {
      automated {
        prune      = true
        self_heal  = true
      }
    }
  }

  depends_on = [helm_release.argocd]
}

resource "argocd_application" "staging_app" {
  metadata {
    name      = "staging-flask-app"
    namespace = "argocd"
  }

  spec {
    project = "default"

    source {
      repo_url        = "https://github.com/noaeisnkut/second_clothes_project.git"
      target_revision = "s3"
      path            = "helm-chart"

      helm {
        value_files = ["values-staging.yaml"]
      }
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "staging"
    }

    sync_policy {
      automated {
        prune      = true
        self_heal  = true
      }
    }
  }

  depends_on = [helm_release.argocd]
}
