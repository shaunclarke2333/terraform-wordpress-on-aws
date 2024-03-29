# Security group for the main-loab-balancer Allow port 443 TCP inbound to ELB.
module "alb_443_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.env}-main-elb-security-group"
  description = "Allow port 443 TCP inbound to alb with custom ports open within VPC"
  vpc_id      = data.terraform_remote_state.level1-main-vpc.outputs.main-vpc-id


  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "${var.env}-https to ELB"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "${var.env}-http to ELB"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "${var.env}-https to ELB"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    name = "${var.env}-main-elb-sg"
  }
}

#Application load balancer
module "main-elb" {
  source = "terraform-aws-modules/alb/aws"

  name = "${var.env}-main-elb"

  load_balancer_type = "application"

  vpc_id          = data.terraform_remote_state.level1-main-vpc.outputs.main-vpc-id
  internal        = false
  subnets         = [for subnet in data.terraform_remote_state.level1-main-vpc.outputs.main-public-subnet : subnet]
  security_groups = [module.alb_443_sg.security_group_id]

  tags = {
    name = "${var.env}-main_elb"
  }

  target_groups = [
    {
      name_prefix          = "${var.env}"
      backend_protocol     = "HTTP"
      backend_port         = 80
      deregistration_delay = 10

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/readme.html"
        port                = "traffic-port"
        healthy_threshold   = 5
        unhealthy_threshold = 3
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  ]

  target_group_tags = {
    name = "${var.env}-main-tg"
  }

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "${module.elb_friendly_name.acm_certificate_output.certificate_arn}"
      action_type        = "forward"
      target_group_index = 0
    }
  ]

  https_listeners_tags = {
    name = "${var.env}-main-alb-listener"
  }

}
