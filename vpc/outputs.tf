output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main_vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block assigned to the VPC"
  value       = aws_vpc.main_vpc.cidr_block
}

output "public_subnet_az_1_id" {
  description = "ID of the first public subnet"
  value       = aws_subnet.public_subnet_az_1.id
}

output "public_subnet_az_2_id" {
  description = "ID of the second public subnet"
  value       = aws_subnet.public_subnet_az_2.id
}

output "private_subnet_az_1_id" {
  description = "ID of the first private subnet"
  value       = aws_subnet.private_subnet_az_1.id
}

output "private_subnet_az_2_id" {
  description = "ID of the second private subnet"
  value       = aws_subnet.private_subnet_az_2.id
}

output "db_subnet_az_1_id" {
  description = "ID of the first database-ready subnet"
  value       = aws_subnet.db_subnet_az_1.id
}

output "db_subnet_az_2_id" {
  description = "ID of the second database-ready subnet"
  value       = aws_subnet.db_subnet_az_2.id
}

output "internet_gateway_id" {
  description = "ID of the internet gateway attached to the VPC"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_az_1_id" {
  description = "ID of the NAT gateway in AZ 1"
  value       = aws_nat_gateway.nat_gw_az_1.id
}

output "nat_gateway_az_2_id" {
  description = "ID of the NAT gateway in AZ 2"
  value       = aws_nat_gateway.nat_gw_az_2.id
}

output "public_subnet_az_2a_id" {
  description = "Compatibility output for the first public subnet"
  value       = aws_subnet.public_subnet_az_1.id
}

output "public_subnet_az_2b_id" {
  description = "Compatibility output for the second public subnet"
  value       = aws_subnet.public_subnet_az_2.id
}
