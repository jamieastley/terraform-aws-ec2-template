terraform {
  backend "s3" {
    # required values provided via env vars
  }
}

module "Apache_Demo" {
  source = "../modules/aws"

  app_name     = var.app_name
  ssh_key_name = var.ssh_key_name

  aws_ami           = var.aws_ami
  aws_instance_type = var.aws_instance_type
  aws_region        = var.aws_region

  ingress_rules = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "HTTP from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
  egress_rules = [
    {
      description      = "Outbound HTTP"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
}