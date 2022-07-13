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
