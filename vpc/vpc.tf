########################################
# VPC MODULE
# - Main VPC for the three-tier architecture
# - Public, private, and database subnets across 2 AZs
# - Internet Gateway for public access
# - NAT Gateways for outbound access from private and database tiers
# - Route tables and associations for each subnet tier
########################################

########################################
# CREATING MAIN VPC
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
# CREATING PUBLIC SUBNET IN AZ 1
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

########################################
# CREATING PUBLIC SUBNET IN AZ 2
########################################
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
# CREATING PRIVATE SUBNET IN AZ 1
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

########################################
# CREATING PRIVATE SUBNET IN AZ 2
########################################
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
# CREATING DATABASE SUBNET IN AZ 1
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

########################################
# CREATING DATABASE SUBNET IN AZ 2
########################################
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
# CREATING INTERNET GATEWAY
########################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-igw"
  })
}

########################################
# CREATING PUBLIC ROUTE TABLE
########################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-rt"
  })
}

########################################
# CREATING PUBLIC DEFAULT ROUTE
########################################
resource "aws_route" "public_default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

########################################
# ASSOCIATING PUBLIC ROUTE TABLE WITH PUBLIC SUBNETS
########################################
resource "aws_route_table_association" "public_rt_assoc_az_1" {
  subnet_id      = aws_subnet.public_subnet_az_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_az_2" {
  subnet_id      = aws_subnet.public_subnet_az_2.id
  route_table_id = aws_route_table.public_rt.id
}

########################################
# CREATING ELASTIC IP FOR NAT GATEWAY IN AZ 1
########################################
resource "aws_eip" "nat_eip_az_1" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-eip-az-1"
  })
}

########################################
# CREATING ELASTIC IP FOR NAT GATEWAY IN AZ 2
########################################
resource "aws_eip" "nat_eip_az_2" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-eip-az-2"
  })
}

########################################
# CREATING NAT GATEWAY IN AZ 1
########################################
resource "aws_nat_gateway" "nat_gw_az_1" {
  allocation_id = aws_eip.nat_eip_az_1.id
  subnet_id     = aws_subnet.public_subnet_az_1.id

  depends_on = [aws_internet_gateway.igw]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw-az-1"
  })
}

########################################
# CREATING NAT GATEWAY IN AZ 2
########################################
resource "aws_nat_gateway" "nat_gw_az_2" {
  allocation_id = aws_eip.nat_eip_az_2.id
  subnet_id     = aws_subnet.public_subnet_az_2.id

  depends_on = [aws_internet_gateway.igw]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw-az-2"
  })
}

########################################
# CREATING PRIVATE ROUTE TABLE IN AZ 1
########################################
resource "aws_route_table" "private_rt_az_1" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt-az-1"
  })
}

########################################
# CREATING PRIVATE ROUTE TABLE IN AZ 2
########################################
resource "aws_route_table" "private_rt_az_2" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt-az-2"
  })
}

########################################
# CREATING PRIVATE DEFAULT ROUTE IN AZ 1
########################################
resource "aws_route" "private_default_route_az_1" {
  route_table_id         = aws_route_table.private_rt_az_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_az_1.id
}

########################################
# CREATING PRIVATE DEFAULT ROUTE IN AZ 2
########################################
resource "aws_route" "private_default_route_az_2" {
  route_table_id         = aws_route_table.private_rt_az_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_az_2.id
}

########################################
# ASSOCIATING PRIVATE ROUTE TABLES WITH PRIVATE SUBNETS
########################################
resource "aws_route_table_association" "private_rt_assoc_az_1" {
  subnet_id      = aws_subnet.private_subnet_az_1.id
  route_table_id = aws_route_table.private_rt_az_1.id
}

resource "aws_route_table_association" "private_rt_assoc_az_2" {
  subnet_id      = aws_subnet.private_subnet_az_2.id
  route_table_id = aws_route_table.private_rt_az_2.id
}

########################################
# CREATING DATABASE ROUTE TABLE IN AZ 1
########################################
resource "aws_route_table" "db_rt_az_1" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-rt-az-1"
  })
}

########################################
# CREATING DATABASE ROUTE TABLE IN AZ 2
########################################
resource "aws_route_table" "db_rt_az_2" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-rt-az-2"
  })
}

########################################
# CREATING DATABASE DEFAULT ROUTE IN AZ 1
########################################
resource "aws_route" "db_default_route_az_1" {
  route_table_id         = aws_route_table.db_rt_az_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_az_1.id
}

########################################
# CREATING DATABASE DEFAULT ROUTE IN AZ 2
########################################
resource "aws_route" "db_default_route_az_2" {
  route_table_id         = aws_route_table.db_rt_az_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_az_2.id
}

########################################
# ASSOCIATING DATABASE ROUTE TABLES WITH DATABASE SUBNETS
########################################
resource "aws_route_table_association" "db_rt_assoc_az_1" {
  subnet_id      = aws_subnet.db_subnet_az_1.id
  route_table_id = aws_route_table.db_rt_az_1.id
}

resource "aws_route_table_association" "db_rt_assoc_az_2" {
  subnet_id      = aws_subnet.db_subnet_az_2.id
  route_table_id = aws_route_table.db_rt_az_2.id
}
