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

#Declaring availability zone data source
data "aws_availability_zones" "available" {
  state = "available"
}

module "main-vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "3.14.2"
  name                   = "main-vpc"
  cidr                   = "10.0.0.0/16"
  azs                    = [for az in data.aws_availability_zones.available.names : az]
  private_subnets        = var.private_subnet_cidr
  public_subnets         = var.public_subnet_cidr
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
}
