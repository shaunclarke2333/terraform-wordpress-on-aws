#Security Group to allow inboound on port 80 and 3306
module "launch-template-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "main-lt-security-group"
  description = "Allow port 80 and 3306 TCP inbound to ec2 ASG instances within VPC"
  vpc_id      = data.terraform_remote_state.level1-main-vpc.outputs.main-vpc-id


  ingress_with_cidr_blocks = [
    { # port 80 ingress rule
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "https to ELB"
      cidr_blocks = "0.0.0.0/0"
    },
    { # port 3306 SQL port ingress rule
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "https to ELB"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "https to ELB"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    name = "main-elb-sg"
  }
}

#Module to deploy autoscaling group with launch template and IAM session manager policy
module "main-autoscaling-group" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "main-autoscaling-group"

  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 4
  health_check_grace_period = 400
  health_check_type         = "EC2"
  vpc_zone_identifier       = [for subnet in data.terraform_remote_state.level1-main-vpc.outputs.main-private-subnet : subnet]
  target_group_arns         = module.main-elb.target_group_arns
  force_delete              = true

  # Launch template
  launch_template_name        = "main-launch-template"
  launch_template_description = "Launch template example"
  update_default_version      = true
  launch_template_version     = "$Latest"

  image_id        = data.aws_ami.amazon_linux.id
  instance_type   = var.instance_type
  key_name        = "main"
  security_groups = ["${module.launch-template-sg.security_group_id}"]
  user_data       = filebase64("bootstrap_webserver.sh")

  tag_specifications = [
    {
      resource_type = "instance"

      tags = {
        Name = "main-ubuntu-launch-template"
      }
    }
  ]

  # IAM role & instand profile
  create_iam_instance_profile = true
  iam_role_name               = "main-ssm-full-access"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role for Sessions Manager"
  iam_role_tags = {
    CustomIamRole = "No"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}
