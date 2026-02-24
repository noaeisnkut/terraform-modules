resource "azurerm_kubernetes_cluster" "mycluster" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.cluster_name}-dns"

  identity {
    type = "SystemAssigned"
  }

  # Enable Workload Identity
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"
  }

  default_node_pool {
    name                         = "systempool"
    vm_size                      = "Standard_DS2_v2"
    node_count                   = 1
    auto_scaling_enabled          = false
    only_critical_addons_enabled  = true
  }

  node_provisioning_profile {
    mode = "Auto"
  }

  tags = local.common_tags
}
