resource "azurerm_kubernetes_cluster" "kubernetes" {
  name                = "salento"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "kubernetes"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    os_sku     = "Ubuntu"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}


data "azurerm_kubernetes_cluster" "credentials" {
  name                = azurerm_kubernetes_cluster.kubernetes.name
  resource_group_name = azurerm_resource_group.default.name
  depends_on = [azurerm_kubernetes_cluster.kubernetes]
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.kubernetes.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.kubernetes.kube_config_raw

  sensitive = true
}