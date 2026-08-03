resource "aws_vpc" "ecs" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-ecs"
  }
}

resource "aws_subnet" "public-2a-ecs" {
  vpc_id            = aws_vpc.ecs.id
  availability_zone = var.availability_zone[0]
  cidr_block        = var.public_subnet_cidr[0]

  tags = {
    Name = "public-2a-ecs"
  }
}

resource "aws_subnet" "public-2b-ecs" {
  vpc_id            = aws_vpc.ecs.id
  availability_zone = var.availability_zone[1]
  cidr_block        = var.public_subnet_cidr[1]

  tags = {
    Name = "public-2b-ecs"
  }
}

resource "aws_subnet" "private-2a-ecs" {
  vpc_id            = aws_vpc.ecs.id
  availability_zone = var.availability_zone[0]
  cidr_block        = var.private_subnet_cidr[0]

  tags = {
    Name = "private-2a-ecs"
  }
}

resource "aws_subnet" "private-2b-ecs" {
  vpc_id            = aws_vpc.ecs.id
  availability_zone = var.availability_zone[1]
  cidr_block        = var.private_subnet_cidr[1]

  tags = {
    Name = "private-2b-ecs"
  }
}

resource "aws_internet_gateway" "ecs" {
  vpc_id = aws_vpc.ecs.id

  tags = {
    Name = "ecs"
  }
}

resource "aws_route_table" "public-ecs" {
  vpc_id = aws_vpc.ecs.id

  route {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.ecs.id
  }

  tags = {
    Name = "public-ecs"
  }
}

resource "aws_route_table" "private-ecs" {
  vpc_id = aws_vpc.ecs.id

  tags = {
    Name = "private-ecs"
  }
}

resource "aws_route_table_association" "public-2a-ecs" {
  subnet_id      = aws_subnet.public-2a-ecs.id
  route_table_id = aws_route_table.public-ecs.id
}

resource "aws_route_table_association" "public-2b-ecs" {
  subnet_id      = aws_subnet.public-2b-ecs.id
  route_table_id = aws_route_table.public-ecs.id
}

resource "aws_route_table_association" "private-2a-ecs" {
  subnet_id      = aws_subnet.private-2a-ecs.id
  route_table_id = aws_route_table.private-ecs.id
}

resource "aws_route_table_association" "private-2b-ecs" {
  subnet_id      = aws_subnet.private-2b-ecs.id
  route_table_id = aws_route_table.private-ecs.id
}