terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27"
    }
  }
}

resource "aws_s3_bucket" "storage_bucket" {
  bucket_prefix = var.bucket_name_prefix

  tags = {
    Name        = var.app_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_request_payment_configuration" "example" {
  bucket = aws_s3_bucket.storage_bucket.id
  payer  = "Requester"
}