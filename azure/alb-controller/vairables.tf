variable "name" {
  type        = string
  description = "Base name for the ALB controller resources and prefix for routes"
  default     = "azure-alb-controller"
}

variable "location" {
  type        = string
}

variable "resource_group_name" {
  type        = string
}

variable "oidc_issuer_url" {
  type        = string
  description = "The OIDC Issuer URL from the AKS cluster (required for Workload Identity)"
}

variable "alb_subnet_id" {
  type        = string
  description = "The ID of the subnet where the Application Gateway for Containers will live"
}

variable "namespace" {
  type        = string
  description = "Namespace where the ALB Controller and ApplicationLoadBalancer resource will live"
  default     = "azure-alb-system"
}

variable "service_account_name" {
  type    = string
  default = "alb-controller-sa"
}

variable "controller_version" {
  type    = string
  default = "1.9.11"
}

# --- HTTPRoute & Gateway Specific Variables ---

variable "alb_resource_name" {
  type        = string
  description = "The name of the ApplicationLoadBalancer custom resource"
  default     = "alb-infra"
}

variable "gateway_name" {
  type        = string
  description = "The name of the Gateway resource that Route 53 will look for"
  default     = "external-gateway"
}

variable "istio_namespace" {
  type        = string
  description = "The namespace where Istio is installed"
  default     = "istio-system"
}

variable "istio_svc_name" {
  type        = string
  description = "The name of the Istio Ingress Gateway service (ClusterIP)"
  default     = "istio-ingressgateway-external"
}

variable "route_name" {
  type        = string
  description = "The name of the HTTPRoute resource"
  default     = "alb-to-istio"
}
variable "route53_zone_id" {
  type        = string
  description = "The ID of the Route 53 hosted zone in AWS"
}

variable "domain_name" {
  type        = string
  description = "The full domain name for the application (e.g., app.example.com)"
}