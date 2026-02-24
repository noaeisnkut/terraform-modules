resource "azurerm_kubernetes_cluster" "mycluster" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.cluster_name}-dns"

  identity {
    type = var.identity_type
  }

  # Enable Workload Identity
  oidc_issuer_enabled       = var.oidc_issuer_enabled
  workload_identity_enabled = var.workload_identity_enabled

  network_profile {
    network_plugin      = var.network_plugin
    network_plugin_mode = var.network_plugin_mode
    network_data_plane  = var.network_data_plane
  }

  default_node_pool {
    name                         = var.node_pool_name
    vm_size                      = var.node_vm_size
    node_count                   = var.node_count
    auto_scaling_enabled          = var.auto_scaling_enabled
    only_critical_addons_enabled  = var.only_critical_addons_enabled
  }

  node_provisioning_profile {
    mode = var.node_provisioning_mode
  }

  tags = var.tags
}