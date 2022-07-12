# Terraform backend configuration to store state file remotely in S3
terraform {
  backend "s3" {
    bucket         = "main-backend-state-bucket"
    key            = "level2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-table"
  }
}
