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
  dns_email_address = var.dns_email_address
  domain_name = var.domain_name
  subdomain_name = var.subdomain_name
  enable_ssl_staging = var.enable_ssl_staging
  zone_id = var.zone_id

  aws_ami           = var.aws_ami
  aws_instance_type = var.aws_instance_type
  aws_region        = var.aws_region

  instance_user_data = templatefile("${path.module}/scripts/init-docker.tftpl", {
    image = "nginxdemos/hello"
    container_name = "nginx-demo"
    command = "nginxdemos/hello"
  })

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