output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_az_1_id" {
  value = aws_subnet.public_subnet_az_1.id
}

output "public_subnet_az_2_id" {
  value = aws_subnet.public_subnet_az_2.id
}

output "private_subnet_az_1_id" {
  value = aws_subnet.private_subnet_az_1.id
}

output "private_subnet_az_2_id" {
  value = aws_subnet.private_subnet_az_2.id
}

output "database_subnet_az_1_id" {
  value = aws_subnet.db_subnet_az_1.id
}

output "database_subnet_az_2_id" {
  value = aws_subnet.db_subnet_az_2.id
}

output "vpc_cidr_block" {
  value = aws_vpc.main_vpc.cidr_block
}