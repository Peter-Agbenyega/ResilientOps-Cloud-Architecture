output "security_group_id" {
  description = "Security group ID attached to the application servers"
  value       = aws_security_group.app_server_sg.id
}

output "launch_template_id" {
  description = "ID of the launch template used by the autoscaling group"
  value       = aws_launch_template.app_launch_template.id
}

output "autoscaling_group_name" {
  description = "Name of the application autoscaling group"
  value       = aws_autoscaling_group.app_asg.name
}
