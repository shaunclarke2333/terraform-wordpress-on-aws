# instance type for ec2
variable "instance_type" {
  description = "instance type for ec2"
  default     = "t2.small"
}

# key to connect to ec2
variable "key_name" {
  description = "key to connect to main-ec2 resource"
  default     = "main"
}

# variable for environment name
variable "env" {
  description = "input variable for environment name"
}

# variable for environment name
variable "install_script" {
  description = "input variable for install_script"
}
