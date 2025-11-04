# Infrastructure Repository Overview

This repository contains the Terraform/Terragrunt configuration to deploy and manage the Kubernetes infrastructure and related resources for this project.

The repository is organized as follows:

- `vpc/` - Terraform module for VPC creation
- `eks/` - Terraform module for EKS cluster creation
- `argocd/` - Terraform/Terragrunt module to deploy ArgoCD for application deployment
- `root/live/<environment>/` - Environment-specific Terragrunt configurations

**Deployment Instructions**

**Initialize, plan, and apply all infrastructure for the environment:**

terragrunt run-all init
terragrunt run-all plan
terragrunt run-all apply
**module infra**:
<img width="343" height="665" alt="image" src="https://github.com/user-attachments/assets/4283f59f-5431-4d2a-8b80-bcec01ed944a" />
