terraform {
  #  Uncomment in your implementation
  #
  #  backend "s3" {
  #    # required values provided via env vars
  #  }
}

data "http" "dev_outbound_ip" {
  url = "https://ipv4.icanhazip.com"
}

module "Nginx_Demo" {
  source = "../modules/aws"

  app_name           = var.app_name
  ssh_key_name       = var.ssh_key_name
  dns_email_address  = var.dns_email_address
  domain_name        = var.domain_name
  subdomain_name     = var.subdomain_name
  enable_ssl_staging = var.enable_ssl_staging
  zone_id            = var.zone_id
  aws_ami            = var.aws_ami
  aws_instance_type  = var.aws_instance_type
  aws_region         = var.aws_region
  s3_bucket_id       = aws_s3_object.docker_compose.bucket

  instance_user_data = templatefile("${path.module}/scripts/init-docker.tftpl", {
    bucket         = var.s3_bucket_name
    username       = var.ec2_username
    base_key_path  = local.s3_base_key_path
  })

  ingress_rules = [
    {
      description      = "Allow SSH connections only from the IP address of the developer"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["${chomp(data.http.dev_outbound_ip.body)}/32"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "HTTP traffic"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description = "HTTPS traffic"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description      = "Allows Valheim game traffic to the server"
      from_port        = 2456
      to_port          = 2458
      protocol         = "udp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "Port which will be used to access Hugin"
      from_port        = 3000
      to_port          = 3000
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
