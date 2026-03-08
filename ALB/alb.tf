# CREATING SECURITY GROUP FOR APPLICATION LOAD BALANCER
resource "aws_security_group" "app_alb_sg" {
  name        = "app-alb-sg"
  description = "Allow HTTP and HTTPS traffic to ALB"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-alb-sg"
  })
}

# CREATING INBOUND RULE FOR HTTP
resource "aws_vpc_security_group_ingress_rule" "allow_http_for_alb" {
  security_group_id = aws_security_group.app_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# CREATING INBOUND RULE FOR HTTPS
resource "aws_vpc_security_group_ingress_rule" "allow_https_for_alb" {
  security_group_id = aws_security_group.app_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# CREATING OUTBOUND RULE FOR ALB SECURITY GROUP
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_for_alb" {
  security_group_id = aws_security_group.app_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# CREATING TARGET GROUP FOR APPLICATION SERVERS
resource "aws_lb_target_group" "app_tg" {
  name        = "app-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200,301,302"
    interval            = 30
    timeout             = 5
    port                = 80
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-tg"
  })
}

# CREATING APPLICATION LOAD BALANCER
resource "aws_lb" "app_alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_alb_sg.id]
  subnets            = [var.public_subnet_az_2a_id, var.public_subnet_az_2b_id]

  enable_deletion_protection = false

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-alb"
  })
}

# CREATING ALB LISTENER FOR HTTP
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-http-listener"
  })
}