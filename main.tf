resource "azurerm_container_registry" "tiulanches_acr" {
  name                = "tiulanchesacr"
  resource_group_name = azurerm_resource_group.tiulanches_rg.name
  location            = azurerm_resource_group.tiulanches_rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "tiulanches_aks" {
  name                = "tiulanches_aks"
  location            = azurerm_resource_group.tiulanches_rg.location
  resource_group_name = azurerm_resource_group.tiulanches_rg.name
  dns_prefix          = "tiulanchesaks"

  default_node_pool {
    name                  = "agentpool"
    type                  = "VirtualMachineScaleSets"
    vm_size               = "Standard_D2_v2"
    os_sku                = "Ubuntu"    
    max_pods              = 30
    enable_node_public_ip = false
    enable_auto_scaling   = true    
    node_count            = 1
    min_count             = 1
    max_count             = 3    
  }

  identity {
    type = "SystemAssigned"
  }
  
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}

resource "azurerm_role_assignment" "aks_to_acr" {
  principal_id                     = azurerm_kubernetes_cluster.tiulanches_aks.kubelet_identity[0].object_id  
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.tiulanches_acr.id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aks_to_rg" {
  scope                = azurerm_resource_group.tiulanches_rg.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.tiulanches_aks.identity[0].principal_id
}

