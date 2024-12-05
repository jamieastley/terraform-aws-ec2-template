terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"
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
}

resource "aws_instance" "app_server" {
  ami             = var.aws_ami
  instance_type   = var.aws_instance_type
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.sg.id]
  key_name        = var.ssh_key_name

  iam_instance_profile = aws_iam_instance_profile.bucket_instance_profile.id

  user_data = var.instance_user_data

  root_block_device {
    volume_type = "gp3"
  }
}
