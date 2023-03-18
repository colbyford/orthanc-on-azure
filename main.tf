// Tags
locals {
  tags = {
    owner       = var.tag_department
    region      = var.tag_region
    environment = var.environment
  }
}

// Existing Resources

/// Subscription ID

data "azurerm_subscription" "current" {
}

// Random Suffix Generator

resource "random_integer" "deployment_id_suffix" {
  min = 100
  max = 999
}

// Resource Group

resource "azurerm_resource_group" "rg" {
  name     = "${var.app_name}-${var.environment}-${random_integer.deployment_id_suffix.result}-rg"
  location = var.location

  tags = local.tags
}


// Container Registry

resource "azurerm_container_registry" "acr" {
  name                = "${var.app_name}${var.environment}${random_integer.deployment_id_suffix.result}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = local.tags
}

// Storage Account

resource "azurerm_storage_account" "storage" {
  name                     = "${var.app_name}${var.environment}${random_integer.deployment_id_suffix.result}st"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.tags
}


resource "azurerm_storage_container" "container" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "blob"
}

// PostgreSQL Database

resource "azurerm_postgresql_server" "pgsql" {
  name                = "${var.app_name}-${var.environment}-${random_integer.deployment_id_suffix.result}-psql"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login          = "psqladmin"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "B_Gen5_2"
  version    = "11"
  storage_mb = 640000

  public_network_access_enabled    = true
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"

  tags = local.tags
}

resource "azurerm_postgresql_database" "db" {
  name                = "orthancdb"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.pgsql.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}


// Health Data Service and DICOM API

resource "azurerm_healthcare_workspace" "hdsw" {
  name                = "${var.app_name}${var.environment}${random_integer.deployment_id_suffix.result}hdsw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  tags = local.tags
}

resource "azurerm_healthcare_dicom_service" "dicom" {
  name         = "${var.app_name}-${var.environment}-${random_integer.deployment_id_suffix.result}-dicom"
  workspace_id = azurerm_healthcare_workspace.hdsw.id
  location     = azurerm_resource_group.rg.location

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}



// App Service Plan

resource "azurerm_service_plan" "asp" {
  name                = "${var.app_name}-${var.environment}-${random_integer.deployment_id_suffix.result}-asp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"

  tags = local.tags
}


// Web App

resource "azurerm_linux_web_app" "app" {
  name                = "${var.app_name}-${var.environment}-${random_integer.deployment_id_suffix.result}-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  app_settings = {
    WEBSITES_PORT                   = "8042"
    DOCKER_REGISTRY_SERVER_URL      = "${azurerm_container_registry.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME = "${azurerm_container_registry.acr.admin_username}"
    DOCKER_REGISTRY_SERVER_PASSWORD = "${azurerm_container_registry.acr.admin_password}"
  }

  site_config {
    always_on = true

    application_stack {
      docker_image     = "${azurerm_container_registry.acr.login_server}/orthanc-viewer-001"
      docker_image_tag = "latest"
    }
  }

  tags = local.tags
}
