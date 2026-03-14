output "jupiter_app_tg_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.app_tg.arn
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = aws_lb.app_alb.dns_name
}

output "alb_zone_id" {
  description = "Route53 zone ID for the application load balancer"
  value       = aws_lb.app_alb.zone_id
}

output "alb_arn" {
  description = "ARN of the application load balancer"
  value       = aws_lb.app_alb.arn
}

output "security_group_id" {
  description = "Security group ID for the application load balancer"
  value       = aws_security_group.app_alb_sg.id
}
