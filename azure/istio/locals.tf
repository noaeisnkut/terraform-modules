locals {
  common_labels = {
    "app.kubernetes.io/managed-by" = "terraform"
    "istio-usage"                  = "ingress-only"
  }

  external_annotations = {
    "service.beta.kubernetes.io/azure-load-balancer-resource-group"           = var.resource_group_name
    "service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path" = "/healthz/ready"
    "service.beta.kubernetes.io/azure-load-balancer-health-probe-port"         = "15021"
  }

  internal_annotations = {
    "service.beta.kubernetes.io/azure-load-balancer-internal"        = "true"
    "service.beta.kubernetes.io/azure-load-balancer-internal-subnet" = var.private_subnet_id
  }
}