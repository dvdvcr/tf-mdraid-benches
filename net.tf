resource "aws_vpc" "vpc_benches" {
  cidr_block           = var.benches_access.vpc_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet_benches" {
  vpc_id            = aws_vpc.vpc_benches.id
  cidr_block        = var.benches_access.net_block
  availability_zone = var.benches_access.az
}

resource "aws_route_table" "rt_benches" {
  vpc_id = aws_vpc.vpc_benches.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_benches.id
  }
}

resource "aws_route_table_association" "rta_benches" {
  subnet_id      = aws_subnet.subnet_benches.id
  route_table_id = aws_route_table.rt_benches.id
}

resource "aws_internet_gateway" "igw_benches" {
  vpc_id = aws_vpc.vpc_benches.id
}

resource "aws_security_group" "sg_benches" {
  name        = "sg_benches"
  description = "sg_benches - inbound from specified /32"
  vpc_id      = aws_vpc.vpc_benches.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.benches_access.ingress_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
