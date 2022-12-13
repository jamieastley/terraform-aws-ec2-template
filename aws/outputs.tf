output "aws_ami" {
  description = "The AMI ID of the created EC2 instance"
  value       = aws_instance.app_server.ami
}

output "app_public_ip" {
  value = aws_instance.app_server.public_ip
}