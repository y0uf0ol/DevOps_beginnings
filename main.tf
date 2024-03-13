terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.95.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "soc_deployment" {
  name     = "soc_deployment"
  location = "North Europe"
  tags = {
    enviroment = "soc"
  }

}

resource "azurerm_log_analytics_workspace" "soc_law" {
  name                = "law-soc-prd1"
  location            = azurerm_resource_group.soc_deployment.location
  resource_group_name = azurerm_resource_group.soc_deployment.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "soc_sentinel" {
  resource_group_name          = azurerm_resource_group.soc_deployment.name
  workspace_name               = azurerm_log_analytics_workspace.soc_law.name
  customer_managed_key_enabled = false
}
