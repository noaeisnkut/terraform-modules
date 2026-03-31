# 1. Identity that the Pod will use to talk to Azure DNS
resource "azurerm_user_assigned_identity" "external_dns" {
  name                = "external-dns-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# 2. Connect the Azure Identity to the Kubernetes Service Account (Workload Identity)
resource "azurerm_federated_identity_credential" "external_dns" {
  name      = "external-dns-federated"
  audience  = ["api://AzureADTokenExchange"]
  issuer    = var.oidc_issuer_url
  parent_id = azurerm_user_assigned_identity.external_dns.id
  subject   = "system:serviceaccount:kube-system:external-dns"
}
resource "azurerm_dns_zone" "this" {
  name                = var.zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "dns_contributor" {
  scope                = azurerm_dns_zone.this.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.external_dns.principal_id
}

# 4. Create the Service Account inside Kubernetes
resource "kubernetes_service_account" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    annotations = {
      "azure.workload.identity/client-id" = azurerm_user_assigned_identity.external_dns.client_id
    }
  }
}

# 5. Install the External-DNS Controller
resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  namespace  = "kube-system"

  set {
    name  = "provider"
    value = "azure"
  }

  # Azure Authentication Settings
  set {
    name  = "azure.resourceGroup"
    value = var.resource_group_name
  }
  set {
    name  = "azure.tenantId"
    value = var.tenant_id
  }
  set {
    name  = "azure.subscriptionId"
    value = var.subscription_id
  }
  set {
    name  = "azure.useWorkloadIdentityExtension"
    value = "true"
  }

  # Tell the pod which source to watch (Gateway API)
  set {
    name  = "sources"
    value = "{gateway-httproute}"
  }

  # Use the Service Account we created above
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }

  set {
    name  = "domainFilters"
    value = "{${var.zone_name}}"
  }

  # Prevents External-DNS from deleting records it doesn't own
  set {
    name  = "txtOwnerId"
    value = "aks-alb-cluster"
  }
}