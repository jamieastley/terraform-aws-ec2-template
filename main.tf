terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.80"
    }
  }

  required_version = ">= 1.10.0"
}

provider "aws" {
  default_tags {
    tags = merge(local.tags, aws_servicecatalogappregistry_application.app_dashboard.application_tag)
  }
}

# Required so as to avoid circular dependency when creating aws_servicecatalogappregistry_application
provider "aws" {
  alias = "application"
  default_tags {
    tags = local.tags
  }
}

resource "aws_instance" "app_server" {
  ami             = var.aws_ami
  instance_type   = var.aws_instance_type
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.sg.id]
  key_name        = aws_key_pair.ec2_key_pair.key_name

  iam_instance_profile = aws_iam_instance_profile.bucket_instance_profile.id

  user_data = var.instance_user_data

  root_block_device {
    volume_type = "gp3"
  }
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "${local.resource_prefix}-tf-key"
  public_key = var.ec2_public_key
}
