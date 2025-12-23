output "bucket_name" {
  value       = aws_s3_bucket.storage_bucket.bucket
  description = "The name of the S3 bucket created by the storage module."
}

output "bucket_region" {
  value       = aws_s3_bucket.storage_bucket.region
  description = "The AWS region where the S3 bucket is created."
}
