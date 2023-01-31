resource "aws_eip" "eip" {
  instance = aws_instance.app_server.id
  vpc = true
}

resource "aws_eip_association" "eip_association" {
  instance_id = aws_instance.app_server.id
  allocation_id = aws_eip.eip.id
}

output "elastic_ip" {
  value = aws_eip.eip.public_ip
}