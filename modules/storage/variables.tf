variable "bucket_name_prefix" {
  type        = string
  description = "The name prefix of the S3 bucket to be created"
}

variable "app_name" {
  type        = string
  description = "The name of the app service that will use this module"
}

variable "environment" {
  type        = string
  description = "The environment in which resources will be deployed (e.g., dev, prod)"
}
