resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${local.environment_name}-vpc"
  }
}

resource "aws_subnet" "alb" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.alb_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.environment_name}-alb-subnet"
    Type = "Public"
  }
}

resource "aws_subnet" "ec2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.ec2_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.environment_name}-ec2-subnet"
    Type = "Public"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.environment_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${local.environment_name}-public-rt"
  }
}

resource "aws_route_table_association" "alb" {
  subnet_id      = aws_subnet.alb.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "ec2" {
  subnet_id      = aws_subnet.ec2.id
  route_table_id = aws_route_table.public.id
}

data "aws_availability_zones" "available" {
  state = "available"
}
