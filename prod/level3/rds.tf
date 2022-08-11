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
module "rds-security-group-1" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.env}-rds-security-group-1"
  description = "${var.env} Allow port 3306 TCP inbound to RDS within VPC."
  vpc_id      = data.terraform_remote_state.level1-main-vpc.outputs.main-vpc-id

  ingress_with_cidr_blocks = [
    { # port 3306 SQL port ingress rule
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "${var.env} inbound to sql"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "${var.env} rds-sg-out"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    name = "${var.env}-main-rds-sg"
  }
}

module "mysql-rds" {
  source = "terraform-aws-modules/rds/aws"

  identifier             = "${var.env}wordpress"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  port                   = "3306"
  db_name                = "${var.env}wordpress"
  username               = "shaun"
  password               = local.main-rds-password
  create_random_password = false

  skip_final_snapshot = true
  multi_az            = false

  vpc_security_group_ids = [module.rds-security-group-1.security_group_id]

  backup_retention_period = 1
  backup_window           = "09:46-10:16"

  tags = {
    Name = "${var.env}-main-mysql-rds"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = [for subnet in data.terraform_remote_state.level1-main-vpc.outputs.main-private-subnet : subnet]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]
}
