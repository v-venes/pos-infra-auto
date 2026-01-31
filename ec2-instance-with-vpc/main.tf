locals {
  project_name = var.project_name
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh-key"
  public_key = var.ssh_key
}

resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.ec2_public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = aws_key_pair.ssh_key.key_name

  tags = {
    name = "${local.project_name}"
  }
}
