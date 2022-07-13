#Declaring availability zone data source
data "aws_availability_zones" "available" {
  state = "available"
}

#Datasource for RDS password secret
data "aws_secretsmanager_secret" "rds-secret" {
  name = "main-rds-password"
}

#Data source to retreive values from secret manager
data "aws_secretsmanager_secret_version" "rds-secret-password" {
  secret_id = data.aws_secretsmanager_secret.rds-secret.id
}

# Using locals to assign the name main-rds-password to the decoded json expression
locals {
  main-rds-password = jsondecode(
    data.aws_secretsmanager_secret_version.rds-secret-password.secret_string
  )["password"]
}

# Security group for to allow inboun traffic om port 3306
module "rds-security-group" {
  source = "terraform-aws-modules/security-group/aws"

}


module "mysql-rds" {
  source = "terraform-aws-modules/rds/aws"

}
