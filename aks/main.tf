resource "azurerm_kubernetes_cluster" "mycluster" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.cluster_name}-dns"

  identity {
    type = "SystemAssigned"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay" 
    network_data_plane   = "cilium" 
  }

  default_node_pool {
    name                = "systempool"
    vm_size             = "Standard_DS2_v2"
    node_count          = 1
    auto_scaling_enabled = false 
  }
}

resource "azapi_update_resource" "enable_nap" {
  type        = "Microsoft.ContainerService/managedClusters@2024-09-01"
  resource_id = azurerm_kubernetes_cluster.mycluster.id
}

resource "azurerm_user_assigned_identity" "flask_app" {
  name                = "${var.environment}-flask-app-identity"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_federated_identity_credential" "flask_app" {
  name                = "fed-flask-app"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.flask_app.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.mycluster.oidc_issuer_url
  subject             = "system:serviceaccount:${var.workload_sa_namespace}:${var.workload_sa_name}"
}

resource "kubernetes_service_account_v1" "flask_app_sa" {
  metadata {
    name      = var.workload_sa_name
    namespace = var.workload_sa_namespace
    annotations = {
      "azure.workload.identity/client-id" = azurerm_user_assigned_identity.flask_app.client_id
    }
    labels = {
      "azure.workload.identity/use" = "true"
    }
  }
}