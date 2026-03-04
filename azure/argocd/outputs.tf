output "argocd" {
  value = {
    username = "admin"
    namespace = "argocd"
    password = data.kubernetes_secret_v1.argocd-secret.data.password
    svc_name = "argocd-server"  
    svc_port = 80
  }
  sensitive = true
}