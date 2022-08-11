# Terraform block with required provider and terraform version listed
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">=0.14.9"
}

# Provider block with region defined
provider "aws" {
  region = "us-east-1"
}

# S3 bucket that holds state file
module "main-s3bucket-folders" {
  source = "../../base/modules/s3folders"
  #Adding folders to S3 bucket
  bucket_folders         = var.bucket_folders
  server_side_encryption = "AES256"
}
