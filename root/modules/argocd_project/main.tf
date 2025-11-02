
resource "kubernetes_manifest" "argocd_project" {
  manifest = yamldecode(file("${path.module}/${var.project_yaml}"))
  depends_on = [helm_release.argocd]
}


resource "argocd_application" "apps" {
  for_each = var.apps

  metadata {
    name      = each.value.name
    namespace = "argocd"
  }

  spec {
    project = var.project_name

    source {
      repo_url        = each.value.repo_url
      target_revision = each.value.target_revision
      path            = each.value.path

      helm {
        value_files = each.value.helm_value_files
      }
    }

    destination {
      server    = each.value.destination_server
      namespace = each.value.destination_namespace
    }

    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }
    }
  }

  depends_on = [kubernetes_manifest.argocd_project]
}
