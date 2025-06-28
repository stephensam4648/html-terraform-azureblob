# variables.tf

variable "subscription_id" {
  description = "Your Azure Subscription ID."
  type        = string
  # A default value is NOT recommended for sensitive data or values that must be explicitly set.
  # Remove this default if you want to force users to provide it via CLI, TF_VARs, or a .tfvars file.
  # default     = "YOUR_AZURE_SUBSCRIPTION_ID_HERE"
}

variable "resource_group_name" {
  description = "The name of the Azure Resource Group."
  type        = string
  default     = "my-static-site-rg"
}

variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
  default     = "Central India" # Consider a region closer to your target audience
}

variable "storage_account_name_prefix" {
  description = "A unique prefix for the Azure Storage Account name. The full name will be generated to ensure global uniqueness."
  type        = string
  default     = "mysamstaticweb" # Suggestion: make this shorter and more personal for uniqueness
}

variable "index_document" {
  description = "The name of the default document for the static website."
  type        = string
  default     = "index.html"
}

variable "error_404_document" {
  description = "The name of the 404 error document for the static website."
  type        = string
  default     = "index.html" # Can be changed to "404.html" if you create one
}

variable "site_content_path" {
  description = "The path to your local static website content directory."
  type        = string
  default     = "site" # Assumes your HTML/images are in a 'site' folder
}
