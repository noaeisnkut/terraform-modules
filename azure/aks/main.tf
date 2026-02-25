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
    network_data_plane  = "cilium"
  }

  default_node_pool {
    name                         = var.node_pool_name
    vm_size                      = var.node_vm_size
    node_count                   = var.node_count
    auto_scaling_enabled          = var.auto_scaling_enabled
    min_count                     = var.min_count
    max_count                     = var.max_count
  }

  tags = local.common_tags
}

