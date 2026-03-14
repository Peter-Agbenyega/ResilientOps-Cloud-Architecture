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

output "iam_role_arn" {
  description = "ARN of the EC2 IAM role"
  value       = module.iam.iam_role_arn
}

output "iam_role_name" {
  description = "Name of the EC2 IAM role"
  value       = module.iam.iam_role_name
}

output "iam_instance_profile_name" {
  description = "Name of the EC2 IAM instance profile"
  value       = module.iam.iam_instance_profile_name
}

output "iam_instance_profile_arn" {
  description = "ARN of the EC2 IAM instance profile"
  value       = module.iam.iam_instance_profile_arn
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = module.alb.alb_dns_name
}

output "autoscaling_group_name" {
  description = "Name of the application autoscaling group"
  value       = module.auto_scaling.autoscaling_group_name
}

output "db_instance_identifier" {
  description = "Identifier of the RDS instance"
  value       = module.rds.db_instance_identifier
}

output "db_instance_endpoint" {
  description = "Connection endpoint of the RDS instance"
  value       = module.rds.db_instance_endpoint
}

output "rds_security_group_id" {
  description = "Security group ID attached to the RDS instance"
  value       = module.rds.rds_security_group_id
}

output "db_subnet_group_name" {
  description = "Name of the DB subnet group used by the RDS instance"
  value       = module.rds.db_subnet_group_name
}
