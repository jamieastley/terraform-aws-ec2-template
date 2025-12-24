terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27"
    }
  }
}

module "example_storage" {
  source             = "../../modules/storage"
  app_name           = "ec2-template-example"
  bucket_name_prefix = "tf-example-storage-bucket-"
  environment        = "dev"
}