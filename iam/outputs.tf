output "iam_role_arn" {
  value = aws_iam_role.ec2_instance_role.arn
}

output "iam_role_name" {
  value = aws_iam_role.ec2_instance_role.name
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_instance_profile.name
}

output "iam_instance_profile_arn" {
  value = aws_iam_instance_profile.ec2_instance_profile.arn
}
