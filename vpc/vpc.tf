########################################
# VPC MODULE
# File: vpc/vpc.tf
# Purpose:
#   - Create a production-style VPC layout across 2 AZs:
#     * 2 Public subnets (AZ-1, AZ-2)
#     * 2 Private subnets (AZ-1, AZ-2)
#     * 2 Database subnets (AZ-1, AZ-2)
#   - Internet Gateway for public routing
#   - NAT Gateways (one per AZ) for private/db outbound internet
#   - Route tables + associations for public/private/db
########################################

########################################
# VPC
########################################
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-main-vpc"
  })
}

########################################
# INTERNET GATEWAY
# - Gives PUBLIC subnets direct internet access
########################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-igw"
  })
}

########################################
# PUBLIC SUBNETS (2 AZs)
# - Instances here can get a public IP
########################################
resource "aws_subnet" "public_subnet_az_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_cidr_blocks[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Tier = "public"
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-subnet-az-1"
  })
}

resource "aws_subnet" "public_subnet_az_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_cidr_blocks[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Tier = "public"
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-subnet-az-2"
  })
}

########################################
# PRIVATE SUBNETS (2 AZs)
# - No public IPs; outbound internet goes via NAT Gateway
########################################
resource "aws_subnet" "private_subnet_az_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_cidr_blocks[0]
  availability_zone = var.availability_zones[0]

  tags = merge(var.tags, {
    Tier = "private"
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-subnet-az-1"
  })
}

resource "aws_subnet" "private_subnet_az_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_cidr_blocks[1]
  availability_zone = var.availability_zones[1]

  tags = merge(var.tags, {
    Tier = "private"
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-subnet-az-2"
  })
}

########################################
# DATABASE SUBNETS (2 AZs)
# - Still private; typically used for RDS
# - Outbound internet (patching, updates) goes via NAT
########################################
resource "aws_subnet" "db_subnet_az_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.database_cidr_blocks[0]
  availability_zone = var.availability_zones[0]

  tags = merge(var.tags, {
    Tier = "database"
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-subnet-az-1"
  })
}

resource "aws_subnet" "db_subnet_az_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.database_cidr_blocks[1]
  availability_zone = var.availability_zones[1]

  tags = merge(var.tags, {
    Tier = "database"
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-subnet-az-2"
  })
}

########################################
# ELASTIC IPs for NAT Gateways (1 per AZ)
# - NAT needs an EIP so it can reach the internet
########################################
resource "aws_eip" "nat_eip_az_1" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-eip-az-1"
  })
}

resource "aws_eip" "nat_eip_az_2" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-eip-az-2"
  })
}

########################################
# NAT GATEWAYS (1 per AZ)
# - Private subnets in AZ-1 route to NAT in AZ-1
# - Private subnets in AZ-2 route to NAT in AZ-2
########################################
resource "aws_nat_gateway" "nat_gw_az_1" {
  allocation_id = aws_eip.nat_eip_az_1.id
  subnet_id     = aws_subnet.public_subnet_az_1.id

  # Helpful in some cases for ordering
  depends_on = [aws_internet_gateway.igw]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw-az-1"
  })
}

resource "aws_nat_gateway" "nat_gw_az_2" {
  allocation_id = aws_eip.nat_eip_az_2.id
  subnet_id     = aws_subnet.public_subnet_az_2.id

  depends_on = [aws_internet_gateway.igw]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw-az-2"
  })
}

########################################
# PUBLIC ROUTE TABLE
# - Default route to the Internet Gateway
########################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-rt"
  })
}

resource "aws_route" "public_default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_rt_assoc_az_1" {
  subnet_id      = aws_subnet.public_subnet_az_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_az_2" {
  subnet_id      = aws_subnet.public_subnet_az_2.id
  route_table_id = aws_route_table.public_rt.id
}

########################################
# PRIVATE ROUTE TABLES (1 per AZ)
# - Default route to NAT in same AZ
########################################
resource "aws_route_table" "private_rt_az_1" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt-az-1"
  })
}

resource "aws_route" "private_default_route_az_1" {
  route_table_id         = aws_route_table.private_rt_az_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_az_1.id
}

resource "aws_route_table_association" "private_rt_assoc_az_1" {
  subnet_id      = aws_subnet.private_subnet_az_1.id
  route_table_id = aws_route_table.private_rt_az_1.id
}

resource "aws_route_table" "private_rt_az_2" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt-az-2"
  })
}

resource "aws_route" "private_default_route_az_2" {
  route_table_id         = aws_route_table.private_rt_az_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_az_2.id
}

resource "aws_route_table_association" "private_rt_assoc_az_2" {
  subnet_id      = aws_subnet.private_subnet_az_2.id
  route_table_id = aws_route_table.private_rt_az_2.id
}

########################################
# DATABASE ROUTE TABLES (1 per AZ)
# - Often DB subnets are kept private too
# - Route to NAT for outbound patching, updates, etc.
########################################
resource "aws_route_table" "db_rt_az_1" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-rt-az-1"
  })
}

resource "aws_route" "db_default_route_az_1" {
  route_table_id         = aws_route_table.db_rt_az_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_az_1.id
}

resource "aws_route_table_association" "db_rt_assoc_az_1" {
  subnet_id      = aws_subnet.db_subnet_az_1.id
  route_table_id = aws_route_table.db_rt_az_1.id
}

resource "aws_route_table" "db_rt_az_2" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-rt-az-2"
  })
}

resource "aws_route" "db_default_route_az_2" {
  route_table_id         = aws_route_table.db_rt_az_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_az_2.id
}

resource "aws_route_table_association" "db_rt_assoc_az_2" {
  subnet_id      = aws_subnet.db_subnet_az_2.id
  route_table_id = aws_route_table.db_rt_az_2.id
}