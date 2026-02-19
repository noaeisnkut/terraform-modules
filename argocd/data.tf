data "kubernetes_secret" "argocd-secret" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
  depends_on = [helm_release.argocd] 
}