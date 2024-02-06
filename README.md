# terraform

Terraform:
1. Azure DevOps Pipeline
2. Storage Accounts
3. Key Vault
4. Subnet
5. NSG + Security Rules
6. SQL MI
7. RBAC
8. TDE
9. AAD Group Access Rights
10. Automation account
11. Alerts

Terrafom local commands:

az storage account keys list -g rg-sqlmi-test-management-terraform -n stoatestmanage

cd C:\Downloads\terraform

terraform init -backend-config="env\atest\backend-config.tfvars"

terraform plan -var-file="env\atest\variables.tfvars" -out="atest.tfplan"

terraform apply "atest.tfplan"

#terraform destroy

cd C:\Downloads\terraform_mgmt

terraform init

terraform plan -out="terraform_mgmt.tfplan"

terraform apply "terraform_mgmt.tfplan"

#terraform destroy
