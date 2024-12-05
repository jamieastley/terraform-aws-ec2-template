resource "aws_servicecatalogappregistry_application" "app_dashboard" {
  provider    = aws.application
  name        = var.app_name
  description = var.app_description
}