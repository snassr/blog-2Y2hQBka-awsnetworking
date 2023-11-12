resource "aws_vpc" "awsnetblog_vpc_01" {
  assign_generated_ipv6_cidr_block = false
  cidr_block                       = "10.1.0.0/16"
  instance_tenancy                 = "default"

  tags = {
    "Name"    = "awsnetblog_vpc_01"
    "Project" = var.project
  }
}

resource "aws_internet_gateway" "awsnetblog_vpc_01-igw" {
  vpc_id = aws_vpc.awsnetblog_vpc_01.id

  tags = {
    "Name"    = "awsnetblog_vpc_01-igw"
    "Project" = var.project
  }
}

# PUBLIC SUBNET

resource "aws_subnet" "awsnetblog_vpc_01-subnet_01_public" {
  assign_ipv6_address_on_creation = false
  availability_zone               = "us-west-2a"
  cidr_block                      = "10.1.1.0/24"
  map_public_ip_on_launch         = false
  vpc_id                          = aws_vpc.awsnetblog_vpc_01.id

  timeouts {}

  tags = {
    "Name"    = "awsnetblog_vpc_01-subnet_01_public"
    "Project" = var.project
  }
}

resource "aws_route_table_association" "awsnetblog_vpc_01-subnet_01_public-rtb_assoc" {
  route_table_id = aws_route_table.awsnetblog_vpc_01-subnet_01_public-rtb.id
  subnet_id      = aws_subnet.awsnetblog_vpc_01-subnet_01_public.id
}

resource "aws_route_table" "awsnetblog_vpc_01-subnet_01_public-rtb" {
  vpc_id = aws_vpc.awsnetblog_vpc_01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.awsnetblog_vpc_01-igw.id
  }

  tags = {
    "Name"    = "awsnetblog_vpc_01-subnet_01_public-rtb"
    "Project" = var.project
  }
}


# PUBLIC SUBNET - NAT GATEWAY (NGW)

resource "aws_eip" "awsnetblog_vpc_01-subnet_01_public-ngw_01-eip_01" {
  tags = {
    "Name"    = "awsnetblog_vpc_01-subnet_01_public-ngw_01-eip_01"
    "Project" = var.project
  }
}

resource "aws_nat_gateway" "awsnetblog_vpc_01-subnet_01_public-ngw_01" {
  subnet_id = aws_subnet.awsnetblog_vpc_01-subnet_01_public.id

  allocation_id = aws_eip.awsnetblog_vpc_01-subnet_01_public-ngw_01-eip_01.id

  tags = {
    "Name"    = "awsnetblog_vpc_01-subnet_01_public-ngw_01"
    "Project" = var.project
  }
}

# PRIVATE SUBNET

resource "aws_subnet" "awsnetblog_vpc_01-subnet_02_private" {
  assign_ipv6_address_on_creation = false
  availability_zone               = "us-west-2a"
  cidr_block                      = "10.1.2.0/24"
  map_public_ip_on_launch         = false
  vpc_id                          = aws_vpc.awsnetblog_vpc_01.id

  timeouts {}

  tags = {
    "Name"    = "awsnetblog_vpc_01-subnet_02_private"
    "Project" = var.project
  }
}

resource "aws_route_table_association" "awsnetblog_vpc_01-subnet_02_private-rtb_assoc" {
  route_table_id = aws_route_table.awsnetblog_vpc_01-subnet_02_private-rtb.id
  subnet_id      = aws_subnet.awsnetblog_vpc_01-subnet_02_private.id
}

resource "aws_route_table" "awsnetblog_vpc_01-subnet_02_private-rtb" {
  vpc_id = aws_vpc.awsnetblog_vpc_01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.awsnetblog_vpc_01-subnet_01_public-ngw_01.id
  }

  tags = {
    "Name"    = "awsnetblog_vpc_01-subnet_02_private-rtb"
    "Project" = var.project
  }
}
