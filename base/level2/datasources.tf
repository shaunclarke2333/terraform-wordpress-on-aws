#This remote data source is for main vpc and main-public0 id
data "terraform_remote_state" "level1-main-vpc" {
  backend = "s3"

  config = {
    bucket = "main-backend-state-bucket"
    key    = "${var.env}-level1/terraform.tfstate"
    region = "us-east-1"
  }
}

# Data source for ubuntu aws_ami 
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

#Data source policy for Amazon EC2 Role to enable AWS Systems Manager service core functionality
data "aws_iam_policy" "session-mamanger-policy" {
  name = "AmazonSSMManagedInstanceCore"
}

# Data source for route 53 hosted zone.
data "aws_route53_zone" "shaunsawslabzone" {
  name         = "shaunsawslab.link"
  private_zone = false
}
