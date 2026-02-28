resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    { Name = "${var.tags["project"]}-${var.tags["environment"]}-vpc" }
  )
}

resource "aws_subnet" "public" {
  count                   = length(var.public_cidr_blocks)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["project"]}-${var.tags["environment"]}-public-${count.index + 1}"
      Tier = "public"
    }
  )
}

resource "aws_subnet" "private" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["project"]}-${var.tags["environment"]}-private-${count.index + 1}"
      Tier = "private"
    }
  )
}

resource "aws_subnet" "database" {
  count             = length(var.database_cidr_blocks)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.database_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["project"]}-${var.tags["environment"]}-db-${count.index + 1}"
      Tier = "database"
    }
  )
}
