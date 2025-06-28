# main.tf

# Configure the AzureRM Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Define an Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Generate a unique storage account name
# We'll append a random string to the prefix to ensure global uniqueness
resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = true
}

# Create an Azure Storage Account for Static Website Hosting
resource "azurerm_storage_account" "static_site" {
  name                     = "${var.storage_account_name_prefix}${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  https_traffic_only_enabled = false # As discussed, set to false for custom domain without CDN initially.
                                    # For production with custom domain, typically use Azure CDN for HTTPS.

  lifecycle {
    ignore_changes = [custom_domain]
  }
}

# Enable Static Website Hosting on the Storage Account
resource "azurerm_storage_account_static_website" "website" {
  storage_account_id = azurerm_storage_account.static_site.id
  index_document     = var.index_document
  error_404_document = var.error_404_document
}

# Use a local-exec provisioner to upload content using Azure CLI
# This ensures dynamic content upload after the storage account is ready.
# Note: This requires Azure CLI to be installed where Terraform is run.
resource "null_resource" "upload_site_content" {
  depends_on = [azurerm_storage_account_static_website.website] # Ensure website is enabled first

  provisioner "local-exec" {
    # Check if the 'site_content_path' directory exists and is not empty
    # This prevents errors if there's no content to upload (e.g., during 'terraform destroy')
    # Use Windows-friendly paths for robustness.
    # The 'index.html' check is a simple way to confirm there's content.
    command = <<-EOT
      if [ -d "${var.site_content_path}" ] && [ -f "${var.site_content_path}/${var.index_document}" ]; then
        az storage blob upload-batch \
          --account-name ${azurerm_storage_account.static_site.name} \
          --destination '$web' \
          --source "${var.site_content_path}" \
          --auth-mode login # Use 'login' mode (Azure CLI authentication) for security
      else
        echo "Source directory '${var.site_content_path}' or '${var.site_content_path}/${var.index_document}' not found. Skipping content upload."
      fi
    EOT
    interpreter = ["bash", "-c"] # For Linux/macOS
  }

  # For Windows systems, you might use:
  # provisioner "local-exec" {
  #   command = <<-EOT
  #     if (Test-Path -Path "${var.site_content_path}" -PathType Container -And Test-Path -Path "${var.site_content_path}\\${var.index_document}") {
  #       az storage blob upload-batch `
  #         --account-name ${azurerm_storage_account.static_site.name} `
  #         --destination '$web' `
  #         --source "${var.site_content_path}" `
  #         --auth-mode login
  #     } else {
  #       Write-Host "Source directory '${var.site_content_path}' or '${var.site_content_path}\\${var.index_document}' not found. Skipping content upload."
  #     }
  #   EOT
  #   interpreter = ["pwsh", "-Command"] # For PowerShell
  # }

}

# Output the public URL of your static website
output "website_url" {
  description = "The primary web endpoint URL of the static website."
  value       = azurerm_storage_account.static_site.primary_web_endpoint
}

output "storage_account_name" {
  description = "The globally unique name of the Azure Storage Account."
  value       = azurerm_storage_account.static_site.name
}
