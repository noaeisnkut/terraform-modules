variable "name" {
  type        = string
  description = "Base name for ALB controller resources and prefix for routes"
  default     = "azure-alb-controller"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be deployed"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where ALB controller and ALB will be deployed"
}

variable "oidc_issuer_url" {
  type        = string
  description = "OIDC Issuer URL from the AKS cluster (for Workload Identity)"
}

variable "alb_subnet_id" {
  type        = string
  description = "Subnet ID where the Application Load Balancer will be deployed"
}

variable "namespace" {
  type        = string
  description = "Namespace for ALB controller and ALB resources"
  default     = "azure-alb-system"
}

variable "service_account_name" {
  type        = string
  description = "Service account for the ALB controller"
  default     = "alb-controller-sa"
}

variable "controller_version" {
  type        = string
  description = "ALB controller Helm chart version"
  default     = "1.9.11"
}

variable "alb_resource_name" {
  type        = string
  description = "Name of the ApplicationLoadBalancer resource"
  default     = "alb-infra"
}

variable "gateway_name" {
  type        = string
  description = "Name of the Gateway resource"
  default     = "external-gateway"
}

variable "argocd_namespace" {
  type        = string
  description = "Namespace where ArgoCD is deployed"
  default     = "argocd"
}

variable "argocd_svc_name" {
  type        = string
  description = "Service name of ArgoCD server (ClusterIP)"
  default     = "argocd-server"
}

variable "argocd_svc_port" {
  type        = number
  description = "Service port of ArgoCD server"
  default     = 80
}

variable "argocd_hostname" {
  type        = string
  description = "Public hostname for ArgoCD (used by HTTPRoute / external-dns)"
}

variable "flask_namespace" {
  type        = string
  description = "Namespace where Flask app is deployed"
  default     = "flask-app"
}

variable "istio_namespace" {
  type        = string
  description = "Namespace where Istio ingress gateway is installed"
  default     = "istio-system"
}

variable "istio_svc_name" {
  type        = string
  description = "Service name of Istio ingress gateway (ClusterIP)"
  default     = "istio-ingressgateway-external"
}

variable "istio_svc_port" {
  type        = number
  description = "Port of Istio ingress gateway service"
  default     = 80
}

variable "flask_hostname" {
  type        = string
  description = "Public hostname for Flask app (used by HTTPRoute / external-dns)"
}