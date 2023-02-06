terraform {
  required_version = ">=1.0.0, < 2.0.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # version = ">= 2.81.0"
      version = ">= 2.79.0"
    }
  }

  #   backend "remote" {
  #     organization = "Tuple"

  #     workspaces {
  #       prefix = "orthanc-Deployment-"
  #     }
  #   }

}

provider "azurerm" {
  features {}
}