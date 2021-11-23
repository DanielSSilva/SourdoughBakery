terraform {
  # see https://www.terraform.io/docs/language/settings/index.html#specifying-a-required-terraform-version   
  required_version = ">= 1.0.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.77.0"
    }
  }
}

# see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
provider "azurerm" {
  # Configuration options
  subscription_id = var.subscription_id
  features {}
}

variable "resource_group" {}
variable "subscription_id" {}
variable "serviceplan_configs" {}
variable "app_service_ghactions_name" {}
variable "app_service_azdevops_name" {}

# see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
data "azurerm_resource_group" "terraform" {
  name      = var.resource_group.name
  #location  = var.resource_group.location
}

# see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_plan
resource "azurerm_app_service_plan" "terraform" {
  name                = var.serviceplan_configs.name 
  kind                = var.serviceplan_configs.kind
  resource_group_name = data.azurerm_resource_group.terraform.name
  location            = data.azurerm_resource_group.terraform.location
  sku {
    tier      = var.serviceplan_configs.sku.tier
    size      = var.serviceplan_configs.sku.size
    
  }
}

# see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service
resource "azurerm_app_service" "ghactions" {
  name                        = var.app_service_ghactions_name
  location                    = data.azurerm_resource_group.terraform.location
  resource_group_name         = data.azurerm_resource_group.terraform.name
  app_service_plan_id         = azurerm_app_service_plan.terraform.id
  client_affinity_enabled     = true
}

# see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service
resource "azurerm_app_service" "azdevops" {
  name                        = var.app_service_azdevops_name
  location                    = data.azurerm_resource_group.terraform.location
  resource_group_name         = data.azurerm_resource_group.terraform.name
  app_service_plan_id         = azurerm_app_service_plan.terraform.id
  client_affinity_enabled     = true
}