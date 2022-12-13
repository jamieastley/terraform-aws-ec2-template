provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "app_server" {
  ami             = var.aws_ami
  instance_type   = var.aws_instance_type
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.sg.id]
  key_name        = var.ssh_key_name

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  EOF

  tags = {
    Name = var.app_name
    Game = var.app_name
  }
}
