How to Use These Files:
Clone your repo: git clone [your-repo-url]

Navigate: cd your-azure-static-portfolio

Place your site content: Ensure your index.html and images folder (with profile.jpg) are inside the site directory.

Create a terraform.tfvars file (Local, NOT committed to Git):
This file will hold the actual values for your variables, especially your subscription_id.

# terraform.tfvars (DO NOT COMMIT THIS FILE TO GITHUB!)

subscription_id         = "YOUR_ACTUAL_AZURE_SUBSCRIPTION_ID"
# resource_group_name     = "my-custom-rg-name" # Uncomment to override default
# location                = "East US"          # Uncomment to override default
# storage_account_name_prefix = "myawesomeblog" # Uncomment to override default
Replace "YOUR_ACTUAL_AZURE_SUBSCRIPTION_ID" with your real Azure Subscription ID.

Security Note: terraform.tfvars should never be committed to a public Git repository, especially if it contains secrets or sensitive IDs. GitHub Actions (or other CI/CD) offers more secure ways to inject these variables (e.g., using GitHub Secrets, Azure Key Vault, or OIDC authentication for the Azure provider).

Initialize Terraform:

Bash

terraform init
Review the plan:

Bash

terraform plan
Apply the changes:

Bash

terraform apply
This setup provides a robust and secure foundation for your Terraform project, making it suitable for sharing on GitHub while keeping sensitive information out of version control.
