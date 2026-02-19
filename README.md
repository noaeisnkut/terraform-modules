
# Azure Kubernetes Infrastructure Modules

This repository is a collection of reusable Terraform modules for building a complete GitOps-ready environment on Azure.

## 📂 Directory Structure

This repository is organized into standalone modules. Each folder contains the necessary logic to deploy a specific layer of the infrastructure.

```text
terraform-modules/
├── aks/              # Azure Kubernetes Service provisioning
├── argocd/           # ArgoCD GitOps controller deployment
├── istio/            # Istio Ingress Gateway (Smart Ingress mode)
├── vnet/             # Virtual Network and Subnet configuration
└── README.md