terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.78.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.47"
    }
  }
}

locals {
  app_name                     = "example-server"
  docker_compose_file          = "docker-compose.yml"
  docker_compose_template_path = "templates/docker-compose.tftpl"
  docker_compose_s3_key_path   = "scripts/${local.docker_compose_file}"
  init_ec2_template_path       = "templates/init-ec2.tftpl"
}

data "http" "dev_outbound_ip" {
  // only get IP if `is_local_debug` is true
  count = var.is_local_debug ? 1 : 0
  url   = "https://ipv4.icanhazip.com"
}

# Create an S3 bucket to store the docker-compose.yaml file
resource "aws_s3_bucket" "example_bucket" {
  bucket_prefix = "terraform-aws-ec2-template-example-"
  force_destroy = true
}

# Upload the docker-compose.yaml file to the S3 bucket
resource "aws_s3_object" "docker_compose" {
  bucket = aws_s3_bucket.example_bucket.id
  key    = local.docker_compose_s3_key_path
  content_base64 = base64encode(templatefile(local.docker_compose_template_path, {
    image = "nginxdemos/hello"
  }))

  etag = filemd5(local.docker_compose_template_path)
}

module "module_example" {
  source            = "../"
  app_name          = local.app_name
  app_description   = "Example app to demo the module with"
  aws_ami           = "ami-0e040c48614ad1327"
  aws_instance_type = "t2.micro"
  ssh_key_name      = "id_dev"
  instance_user_data = templatefile(local.init_ec2_template_path, {
    bucket                     = aws_s3_bucket.example_bucket.bucket
    docker_compose_s3_key_path = local.docker_compose_s3_key_path
    app_name                   = local.app_name
    docker_compose_file        = local.docker_compose_file
    username                   = "ubuntu"
  })
  s3_arn_allow_list = [
    "arn:aws:s3:::${aws_s3_bucket.example_bucket.id}/*"
  ]
  ingress_rules = flatten([
    [
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
    ],
    length(data.http.dev_outbound_ip) != 0 ? [
      {
        description      = "Allow SSH connections only from the IP address of the developer"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["${chomp(data.http.dev_outbound_ip[0].response_body)}/32"]
        ipv6_cidr_blocks = ["::/0"]
      }
    ] : []
  ])
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

resource "cloudflare_record" "record" {
  zone_id = var.cloudflare_zone_id
  name    = local.app_name
  type    = "A"
  proxied = true
  value   = module.module_example.elastic_ip
}