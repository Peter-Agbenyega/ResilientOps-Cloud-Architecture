output "bastion_host_id" {
  description = "ID of the bastion host"
  value       = aws_instance.bastion_host.id
}

output "bastion_host_public_ip" {
  description = "Public IP address of the bastion host"
  value       = aws_instance.bastion_host.public_ip
}

output "private_server_az1a_id" {
  description = "ID of the first private EC2 host"
  value       = aws_instance.private_server_az1a.id
}

output "private_server_az1b_id" {
  description = "ID of the second private EC2 host"
  value       = aws_instance.private_server_az1b.id
}

output "private_server_sg_id" {
  description = "Security group ID for the private EC2 hosts"
  value       = aws_security_group.private_server_sg.id
}
