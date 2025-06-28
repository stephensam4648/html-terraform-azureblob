# versions.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Use a version constraint appropriate for your setup
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0" # Required for the random_string resource used for unique naming
    }
  }
  required_version = ">= 1.0" # Minimum Terraform version required
}
