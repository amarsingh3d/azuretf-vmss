provider "azurerm" {
  features {

  }

}

terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

terraform {
  required_version = "~> 1.7.5"
}


# provider "azuread" {
#   # Configuration options
# }
