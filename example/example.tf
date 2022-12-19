terraform {
  #  backend "s3" {
  #    # required values provided via env vars
  #  }
}

data "http" "dev_outbound_ip" {
  url = "http://ipv4.icanhazip.com"
}

module "Nginx_Demo" {
  source = "../modules/aws"

  app_name     = var.app_name
  ssh_key_name = var.ssh_key_name

  aws_ami           = var.aws_ami
  aws_instance_type = var.aws_instance_type
  aws_region        = var.aws_region

  instance_user_data = module.container-server.cloud_config

  ingress_rules = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["${chomp(data.http.dev_outbound_ip.body)}/32"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "HTTP from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description = "https"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "traefik"
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_route53_record" "subdomain_record" {
  zone_id = var.zone_id
  name    = var.subdomain_name
  type    = "A"
  records = [module.Nginx_Demo.app_public_ip]
  ttl     = "180"
}

module "container-server" {
  source  = "christippett/container-server/cloudinit"
  version = "~> 1.2"

  domain = "${var.subdomain_name}.${var.domain_name}"
  email  = var.dns_email_address

  letsencrypt_staging = var.enable_letsencrypt_staging

  container = {
    image = "nginxdemos/hello"
  }

  env = {
    TRAEFIK_API_DASHBOARD = true
    TRAEFIK_ENABLED       = true
  }
}