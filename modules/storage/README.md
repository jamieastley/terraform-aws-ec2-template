# Storage Terraform Module

This module provisions an AWS S3 bucket with request payment configuration.

## Inputs

- `bucket_name_prefix` (string): Prefix for the S3 bucket name.
- `app_name` (string): Name of the app using this bucket.
- `environment` (string): Deployment environment (e.g., dev, prod).

## Required Environment Variables

This module requires AWS credentials to be set in your environment. You can provide them using environment variables:

- `AWS_ACCESS_KEY_ID`: Your AWS access key ID
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key
- `AWS_REGION`: AWS region to deploy resources (e.g., ap-southeast-2)

## Usage

```hcl
module "storage" {
  source             = "./modules/storage"
  bucket_name_prefix = "myapp-storage-"
  app_name           = "myapp"
  environment        = "dev"
}
```

## Outputs

- `bucket_name`: The name of the S3 bucket created by the storage module.
- `bucket_region`: The AWS region where the S3 bucket is created.
