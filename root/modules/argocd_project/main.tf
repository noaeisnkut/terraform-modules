
resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_version
  create_namespace = true

  values = [
    file("${path.module}/helm-chart/values-dev.yaml"),
    file("${path.module}/helm-chart/values-staging.yaml"),
    file("${path.module}/helm-chart/values-prod.yaml")
  ]
  wait    = true
  timeout = 600
}
resource "kubernetes_manifest" "argocd_project" {
  depends_on = [helm_release.argocd]

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "AppProject"
    metadata = {
      name      = "my-argocd-project"
      namespace = "argocd"
    }
    spec = {
      description = "Development + Staging + Production environments"
      sourceRepos = ["https://github.com/noaeisnkut/second_clothes_project.git"]
      destinations = [
        { namespace = "dev", server = "https://kubernetes.default.svc" },
        { namespace = "staging", server = "https://kubernetes.default.svc" },
        { namespace = "prod", server = "https://kubernetes.default.svc" },
        { namespace = "argocd", server = "https://kubernetes.default.svc" }
      ]
    }
  }
}
resource "kubernetes_manifest" "apps" {
  for_each = var.apps
  depends_on = [kubernetes_manifest.argocd_project]

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = each.value.name
      namespace = "argocd"
    }
    spec = {
      project = var.project_name
      source = {
        repoURL        = each.value.repo_url
        targetRevision = each.value.target_revision
        path           = each.value.path
      }
      destination = {
        server    = each.value.destination_server
        namespace = each.value.destination_namespace
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}

