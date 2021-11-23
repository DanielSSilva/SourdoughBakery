resource_group = {
  name = "dev-talks-devops-rg"
  location = "northeurope"
}

serviceplan_configs = {
  name = "plan-sourdoughbakery-dev-ne-01"
  kind = "app"
  sku = {
    tier     = "Shared"
    size     = "D1"
  }
}

app_service_ghactions_name = "app-sourdoughbakery-ghactions-ne-01"

app_service_azdevops_name = "app-sourdoughbakery-azdevops-ne-01"