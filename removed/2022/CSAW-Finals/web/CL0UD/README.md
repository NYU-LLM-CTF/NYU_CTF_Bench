# Cloudsec
## Requirements:
terraform

awscli~=1.18.110

***Make sure that you create a separate aws profile for this challenge on AWS with an IAM user who has administrator privileges!***

## Deployment steps:
``` cd ``` into the terraform directory and run the ``` start.sh ``` script to generate the key pair
### Terraform Init step:
```
terraform init 
```
### Terraform Plan step: (Alternatively use .tfvars file to store and use variables)
```
terraform plan -var "profile=<aws_user_profile>"
  ```
### Terraform Apply step: (Alternatively use .tfvars file to store and use variables)
```
terraform apply -var "profile=<aws_user_profile>"
  ```
### Finally - Terraform Destroy: (Alternatively use .tfvars file to store and use variables)
```
terraform destroy -var "profile=<aws_user_profile>" 
  ```
