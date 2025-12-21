terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" # Specify the source of the AWS provider
      version = ">= 6.27"       # Use a version of the AWS provider that is compatible with version
    }
  }
}

module "oidc_role" {
  source         = "../../modules/iam"
  app_name       = "example-server"
  aws_account_id = var.aws_account_id
  oidc_subjects  = ["${var.organisation_name}/${var.repository_name}:*"]
  s3_bucket_name = var.s3_bucket_name
}

output "role_arn" {
  value = module.oidc_role.oidc_role_arn
}
