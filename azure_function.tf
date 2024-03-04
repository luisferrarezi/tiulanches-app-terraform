resource "azurerm_storage_account" "tiulanches_sa" {
  name                     = "tiulanchessa"
  resource_group_name      = azurerm_resource_group.tiulanches_rg.name
  location                 = azurerm_resource_group.tiulanches_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [azurerm_resource_group.tiulanches_rg]  
}

resource "azurerm_service_plan" "tiulanches_sp" {
  name                = "tiulanches_sp"
  location            = azurerm_resource_group.tiulanches_rg.location
  resource_group_name = azurerm_resource_group.tiulanches_rg.name
  os_type             = "Linux"
  sku_name            = "Y1"
  
  depends_on = [azurerm_resource_group.tiulanches_rg]  
}

resource "azurerm_linux_function_app" "tiulanches_auth_function" {
  name                       = "tiulanches-auth-function"
  location                   = azurerm_resource_group.tiulanches_rg.location
  resource_group_name        = azurerm_resource_group.tiulanches_rg.name  
  storage_account_name       = azurerm_storage_account.tiulanches_sa.name
  storage_account_access_key = azurerm_storage_account.tiulanches_sa.primary_access_key
  service_plan_id            = azurerm_service_plan.tiulanches_sp.id    

  site_config {
    application_stack {
      java_version = "17"
    }
  }

  depends_on = [azurerm_resource_group.tiulanches_rg]  
}