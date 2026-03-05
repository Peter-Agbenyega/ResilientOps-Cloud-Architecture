output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = module.ec2.bastion_public_ip
}

output "bastion_public_dns" {
  description = "Public DNS of the bastion host"
  value       = module.ec2.bastion_public_dns
}