output "aws_ami" {
  description = "The AMI ID of the created EC2 instance"
  value       = module.Nginx_Demo.aws_ami
}

output "elastic_ip" {
    value = module.Nginx_Demo.elastic_ip
}