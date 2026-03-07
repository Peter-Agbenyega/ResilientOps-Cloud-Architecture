output "security_group_id" {
  value = aws_security_group.basic_host_sg.id
}

output "launch_template_id" {
  value = aws_launch_template.app_lt.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.app_asg.name
}