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

# Provider block with region defined.
provider "aws" {
  region = "us-east-1"
}

# DNS CNAME record that will point to the live environment
module "cname_pointer" {
  source        = "../modules/route53"
  zone_id       = data.aws_route53_zone.shaunsawslabzone.id
  record_name   = "blue-green.shaunsawslab.link"
  record_type   = "CNAME"
  cname_ttl     = 2
  cname_records = ["${var.live_env}"]
}
