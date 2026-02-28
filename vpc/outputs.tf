output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet_az_1.id,
    aws_subnet.public_subnet_az_2.id
  ]
}