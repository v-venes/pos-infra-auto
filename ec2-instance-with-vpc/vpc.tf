resource "aws_vpc" "ec2_vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    name = local.project_name
  }
}

resource "aws_internet_gateway" "ec2_igw" {
  vpc_id = aws_vpc.ec2_vpc.id

  tags = {
    name = local.project_name
  }
}

resource "aws_subnet" "ec2_public_subnet" {
  vpc_id                  = aws_vpc.ec2_vpc.id
  cidr_block              = "10.0.0.0/26"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    name = "${local.project_name}"
  }
}

resource "aws_route_table" "ec2_route_table" {
  vpc_id = aws_vpc.ec2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ec2_igw.id
  }


  tags = {
    name = "${local.project_name}"
  }
}

resource "aws_route_table_association" "ec2_route_table_association" {
  subnet_id      = aws_subnet.ec2_public_subnet.id
  route_table_id = aws_route_table.ec2_route_table.id
}

resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_security_group"
  description = "Allow SSH and HTTP connections"
  vpc_id      = aws_vpc.ec2_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow internet traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "${local.project_name}"
  }
}
