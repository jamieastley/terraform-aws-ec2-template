# Provides the available zones based on the given region in `aws` provider
data "aws_availability_zones" "available_zones" {}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.app_name} VPC"
    Game = var.app_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.app_name} VPC IGW"
    Game = var.app_name
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "${var.app_name} Public Subnet"
    Game = var.app_name
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.app_name} Public Route Table"
    Game = var.app_name
  }
}

resource "aws_route_table_association" "public_rt_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
