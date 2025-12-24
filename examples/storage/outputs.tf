output "bucket_name" {
  value       = module.example_storage.bucket_name
  description = "The name of the S3 bucket created by the storage module."
}

output "bucket_region" {
  value       = module.example_storage.bucket_region
  description = "The AWS region where the S3 bucket is created."
}
