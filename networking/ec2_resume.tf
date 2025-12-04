
variable "region" {
  default = "ap-south-1"
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  default = true
}


data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

locals {
  subnet_id = data.aws_subnets.public_subnets.ids[0]
}

resource "aws_key_pair" "resume_key" {
  key_name   = "resume-key"
  public_key = file("C:/Users/LENOVO/.ssh/id_rsa.pub") # <- adjust path if needed
}

resource "aws_security_group" "resume_sg" {
  name        = "resume-sg"
  description = "Allow SSH from my IP, HTTP from anywhere"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [chomp(file("${path.module}/my_ip_cidr.txt"))] # ensure my_ip_cidr.txt exists in this folder
    description = "SSH from my IP only"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP public"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "resume-sg"
  }
}

data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "resume" {
  ami                         = data.aws_ami.amazon_linux2.id
  instance_type               = "t2.micro"
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [aws_security_group.resume_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.resume_key.key_name

  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name = "resume-web"
    Owner = "Raghav" # change or remove as you like
  }
}

output "instance_id" {
  value = aws_instance.resume.id
}

output "public_ip" {
  value = aws_instance.resume.public_ip
}
