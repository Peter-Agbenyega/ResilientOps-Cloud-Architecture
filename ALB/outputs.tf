output "alb_security_group_id" {
  value = aws_security_group.app_alb_sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.app_tg.arn
}

output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.app_alb.zone_id
}

output "alb_arn" {
  value = aws_lb.app_alb.arn
}