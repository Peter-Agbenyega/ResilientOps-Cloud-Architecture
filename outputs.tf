output "vpc_id" {
  description = "ID of the primary VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_az_1_id" {
  description = "ID of the first public subnet"
  value       = module.vpc.public_subnet_az_1_id
}

output "public_subnet_az_2_id" {
  description = "ID of the second public subnet"
  value       = module.vpc.public_subnet_az_2_id
}

output "private_subnet_az_1_id" {
  description = "ID of the first private subnet"
  value       = module.vpc.private_subnet_az_1_id
}

output "private_subnet_az_2_id" {
  description = "ID of the second private subnet"
  value       = module.vpc.private_subnet_az_2_id
}

output "bastion_host_public_ip" {
  description = "Public IP address of the bastion host"
  value       = module.ec2.bastion_host_public_ip
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = module.alb.alb_dns_name
}

output "autoscaling_group_name" {
  description = "Name of the application autoscaling group"
  value       = module.auto_scaling.autoscaling_group_name
}
