output "argocd" {
  description = "Argocd_Info"
  value = {
    username = "admin",
    password = nonsensitive(data.kubernetes_secret_v1.argocd-secret.data.password),
    url      = var.argocd_config.hostname
  }
}