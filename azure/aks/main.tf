resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix != null ? var.dns_prefix : "${var.cluster_name}-dns"
  node_resource_group = "${var.resource_group_name}-nodes"

  role_based_access_control_enabled = var.enable_rbac

  identity {
    type = var.identity_type
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  network_profile {
    network_plugin      = var.network_plugin
    network_plugin_mode = var.network_plugin_mode
    network_data_plane  = var.network_data_plane
    pod_cidr            = var.pod_cidr
    service_cidr        = var.service_cidr
    dns_service_ip      = var.dns_service_ip
    load_balancer_sku   = "standard"
  }

  default_node_pool {
    name                  = var.default_node_pool_name
    vm_size               = var.default_node_vm_size
    vnet_subnet_id        = var.aks_subnet_id
    auto_scaling_enabled  = var.default_auto_scaling_enabled
    node_count            = var.default_auto_scaling_enabled ? null : var.default_node_count
    min_count             = var.default_auto_scaling_enabled ? var.default_min_count : null
    max_count             = var.default_auto_scaling_enabled ? var.default_max_count : null
    type                  = "VirtualMachineScaleSets"
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "extra_fixed" {
  for_each              = var.extra_node_pools_fixed
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  vnet_subnet_id        = each.value.subnet_id
  auto_scaling_enabled  = false
  tags                  = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "extra_autoscale" {
  for_each              = var.extra_node_pools_autoscale
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = each.value.vm_size
  vnet_subnet_id        = each.value.subnet_id
  auto_scaling_enabled  = true
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  tags                  = var.tags
}