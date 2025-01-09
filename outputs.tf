output "aws_ami" {
  description = "The AMI ID of the created EC2 instance"
  value       = aws_instance.app_server.ami
}

output "elastic_ip" {
  description = "The Elastic IP assigned to the created EC2 instance"
  value       = aws_eip.eip.public_ip
}

output "app_dashboard_tag" {
  description = "The tag for the created application dashboard"
  value       = aws_servicecatalogappregistry_application.app_dashboard.application_tag
}