# CREATING SECURITY GROUP FOR APPLICATION SERVERS
resource "aws_security_group" "app_server_sg" {
  name        = "app-server-sg"
  description = "Allow bastion SSH and ALB web traffic"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-app-server-sg"
  })
}

# CREATING INBOUND RULE FOR SSH ACCESS
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_for_app_server" {
  security_group_id            = aws_security_group.app_server_sg.id
  referenced_security_group_id = var.bastion_security_group_id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}

# CREATING INBOUND RULE FOR HTTP
resource "aws_vpc_security_group_ingress_rule" "allow_http_for_app_server" {
  security_group_id            = aws_security_group.app_server_sg.id
  referenced_security_group_id = var.alb_security_group_id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

# CREATING OUTBOUND RULE FOR APPLICATION SERVER SECURITY GROUP
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.app_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# GETTING ACTUAL AMI ID FROM SSM PARAMETER STORE


# CREATING LAUNCH TEMPLATE FOR APPLICATION SERVERS


# CREATING LAUNCH TEMPLATE FOR APPLICATION SERVERS
data "aws_ssm_parameter" "app_server_ami" {
  name = var.ami_id
}

resource "aws_launch_template" "app_launch_template" {
  name_prefix   = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-lt-"
  image_id      = data.aws_ssm_parameter.app_server_ami.value
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.app_server_sg.id]

  user_data = base64encode(file("${path.module}/../scripts/jupiter-app-deployment.sh"))

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.tags, {
      Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-app-instance"
    })
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-app-lt"
  })
}

# CREATING AUTO SCALING GROUP FOR APPLICATION SERVERS
resource "aws_autoscaling_group" "app_asg" {
  name                      = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-asg"
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  vpc_zone_identifier       = [var.private_subnet_az_1_id, var.private_subnet_az_2_id]
  target_group_arns         = [var.jupiter_app_tg_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-asg-instance"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
