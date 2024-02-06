az storage account keys list -g rg-sqlmi-test-management-terraform -n stoatestmanage

terraform init -backend-config="storage_account_name=terateststate" -backend-config="container_name=stest" -backend-config="key=terraform.tfstate"  -backend-config="resource_group_name=rg-sqlmi-test-management-terraform" 
terraform validate
terraform fmt
terraform plan -var-file="env\stest\variables.tfvars" -out="stest.tfplan"
terraform apply stest.tfplan
#terraform destroy

#####

terraform init -backend-config="storage_account_name=terateststate" -backend-config="container_name=atest" -backend-config="key=terraform.tfstate"  -backend-config="resource_group_name=rg-sqlmi-test-management-terraform" 
terraform validate
terraform fmt
terraform plan -var-file="env\atest\variables.tfvars" -out="atest.tfplan"
terraform apply atest.tfplan
#terraform destroy