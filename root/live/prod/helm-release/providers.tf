provider "argocd" {
  server_addr = "argocd-server.argocd.svc.cluster.local:443"
  insecure    = true
  username    = "admin"
  password    = var.argocd_password
}
