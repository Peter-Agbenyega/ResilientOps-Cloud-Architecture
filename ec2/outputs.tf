output "bastion_host_id" {
  value = aws_instance.bastion_host.id
}

output "bastion_host_public_ip" {
  value = aws_instance.bastion_host.public_ip
}

output "private_server_az1a_id" {
  value = aws_instance.private_server_az1a.id
}

output "private_server_az1b_id" {
  value = aws_instance.private_server_az1b.id
}

output "private_server_sg_id" {
  value = aws_security_group.private_server_sg.id
}