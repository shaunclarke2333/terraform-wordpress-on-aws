#Declaring availability zone data source
data "aws_availability_zones" "available" {
  state = "available"
}

#This remote data source is for main vpc and main-public0 id
data "terraform_remote_state" "level1-main-vpc" {
  backend = "s3"

  config = {
    bucket = "main-backend-state-bucket"
    key    = "level1/terraform.tfstate"
    region = "us-east-1"
  }
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

#DB subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  description = "mysql-database-main subnet group"
  name        = "mysql-database-main-20220707190516434500000002"

  subnet_ids = [
    "subnet-024ffda9a12511d6b",
    "subnet-02d4bb9df8d5cfcec",
  ]

  tags = {
    "Name" = "mysql-database-main"
  }

  tags_all = {
    "Name" = "mysql-database-main"
  }
}

# parameter group to definemysql config settings
resource "aws_db_parameter_group" "db_parameter_group" {
  description = "mysql-database-main parameter group"
  family      = "mysql5.7"
  name        = "mysql-database-main-20220707190516441700000005"

  tags = {
    "Name" = "mysql-database-main"
  }

  tags_all = {
    "Name" = "mysql-database-main"
  }

  parameter {
    apply_method = "immediate"
    name         = "character_set_client"
    value        = "utf8mb4"
  }

  parameter {
    apply_method = "immediate"
    name         = "character_set_server"
    value        = "utf8mb4"
  }
}

#RDS options group
resource "aws_db_option_group" "options-group" {
  engine_name              = "mysql"
  major_engine_version     = "5.7"
  name                     = "mysql-database-main-20220707190516433900000001"
  option_group_description = "mysql-database-main option group"

  tags = {
    "Name" = "mysql-database-main"
  }

  tags_all = {
    "Name" = "mysql-database-main"
  }

  timeouts {}
}

#RDS security group
resource "aws_security_group" "rds-security-group" {
  description = "Allow port 3306 TCP inbound to RDS within VPC."
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "rds-sg-out"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 65535
    },
  ]

  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "inbound to sql"
      from_port        = 3306
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 3306
    },
  ]
  name = "rds-security-group-20220707190516443200000007"

  tags = {
    "Name" = "rds-security-group"
    "name" = "main-rds-sg"
  }

  tags_all = {
    "Name" = "rds-security-group"
    "name" = "main-rds-sg"
  }

  vpc_id = "vpc-0e90509d55b90dd15"

  timeouts {}
}

# RDS instance
resource "aws_db_instance" "mysql-rds" {
  allocated_storage                     = 20
  auto_minor_version_upgrade            = true
  availability_zone                     = "us-east-1b"
  backup_retention_period               = 1
  backup_window                         = "09:46-10:16"
  ca_cert_identifier                    = "rds-ca-2019"
  copy_tags_to_snapshot                 = false
  customer_owned_ip_enabled             = false
  db_subnet_group_name                  = aws_db_subnet_group.db_subnet_group.name
  delete_automated_backups              = true
  deletion_protection                   = false
  enabled_cloudwatch_logs_exports       = []
  engine                                = "mysql"
  engine_version                        = "5.7.37"
  iam_database_authentication_enabled   = false
  identifier                            = "mysql-database-main"
  instance_class                        = "db.t3.micro"
  iops                                  = 0
  kms_key_id                            = "arn:aws:kms:us-east-1:003729975368:key/5466a61e-507e-40ae-8065-e965a58d1cd8"
  license_model                         = "general-public-license"
  maintenance_window                    = "mon:06:18-mon:06:48"
  max_allocated_storage                 = 0
  monitoring_interval                   = 0
  multi_az                              = false
  db_name                               = "mydb"
  option_group_name                     = aws_db_option_group.options-group.name
  parameter_group_name                  = aws_db_parameter_group.db_parameter_group.name
  performance_insights_enabled          = false
  performance_insights_retention_period = 0
  port                                  = 3306
  publicly_accessible                   = false
  security_group_names                  = []
  skip_final_snapshot                   = true
  storage_encrypted                     = true
  storage_type                          = "gp2"

  tags = {
    "Name" = "main-mysql-rds"
  }

  tags_all = {
    "Name" = "main-mysql-rds"
  }

  username               = "shaun"
  vpc_security_group_ids = [aws_security_group.rds-security-group.id]

  timeouts {}
}

