locals {
  oidc_issuer = replace(var.aks_oidc_issuer_url, "https://", "")
  
  common_tags = {
    Environment = var.environment
    App         = "Flask"
  }
}