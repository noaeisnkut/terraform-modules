include "root" {
  path = "../../../root.hcl"
}

terraform {
  source = "../../../modules/argocd_project"
}

dependency "eks" {
  config_path = "../eks"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs = {
    cluster_name                      = "dev-eks-cluster"
    cluster_endpoint                  = "https://mock-endpoint"
    cluster_certificate_authority_data = base64encode("mock-ca")
    cluster_token                     = "mock-token"
    oidc_issuer_url                    = "https://mock-oidc-url"
  }
}

inputs = {
  cluster_name                       = dependency.eks.outputs.cluster_name
  cluster_endpoint                   = dependency.eks.outputs.cluster_endpoint
  cluster_certificate_authority_data = dependency.eks.outputs.cluster_certificate_authority_data
  cluster_token                       = dependency.eks.outputs.cluster_token
  oidc_issuer_url                     = dependency.eks.outputs.oidc_issuer_url
  project_name                        = "my-argocd-project"

  apps = {
    dev_manifest = {
      name                  = "dev-manifest"
      repo_url              = "https://github.com/noaeisnkut/second_clothes_project.git"
      target_revision       = "main"
      path                  = "argocd/argocd-apps/dev"
      helm_value_files      = []
      destination_namespace = "dev"
      destination_server    = "https://kubernetes.default.svc"
    }
    stage_manifest = {
      name                  = "stage-manifest"
      repo_url              = "https://github.com/noaeisnkut/second_clothes_project.git"
      target_revision       = "main"
      path                  = "argocd/argocd-apps/staging"
      helm_value_files      = []
      destination_namespace = "staging"
      destination_server    = "https://kubernetes.default.svc"
    }
  }
}