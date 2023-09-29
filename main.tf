provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = var.tags
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pub_subnet_cidr
  availability_zone = var.azs
  tags = var.tags
}

resource "aws_subnet" "main1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pri_subnet_cidr
  availability_zone = var.azs
  tags = var.tags
}

resource "aws_instance" "main" {
  ami                         = "ami-03a6eaae9938c858c"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.main.id
  availability_zone           = var.azs
  security_groups             = [aws_security_group.sg.id ]
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }  
  tags = var.tags
}


resource "aws_security_group" "sg" {
  name        = "assigment_sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["52.90.216.224/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "ig" {
    vpc_id = aws_vpc.main.id
    tags = var.tags
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
   tags = var.tags
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}
