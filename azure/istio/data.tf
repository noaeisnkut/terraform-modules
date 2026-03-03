data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_id
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "istio_private" {
  name                 = var.private_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "kubernetes_service_v1" "external_gw" {
  count = var.istio_enable_external_gateway ? 1 : 0

  metadata {
    name      = "istio-ingressgateway-external"
    namespace = var.istio_release_namespace
  }

  depends_on = [helm_release.istio_gateway_external[0]]
}
