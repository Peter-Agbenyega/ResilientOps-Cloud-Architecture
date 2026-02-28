########################################
# EC2 MODULE
# - Bastion Host (public subnet)
# - SSH restricted by allowed CIDR
########################################

########################################
# DATA SOURCE: AMI FROM SSM PARAMETER STORE
# NOTE:
# - ami_id is NOT a raw ami-xxxx here
# - we pass an SSM path like:
#   /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64
########################################
data "aws_ssm_parameter" "bastion_ami" {
  name = var.ami_id
}

########################################
# BASTION SECURITY GROUP
# - Ingress: SSH (22) ONLY from allowed CIDR
# - Egress: allow all outbound
########################################

resource "aws_security_group" "bastion_host_sg" {
  name        = "bastion-host-sg"
  description = "Allow SSH traffic"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-bastion-host-sg"
  })
}

########################################
# INGRESS RULE (SSH)
# - DO NOT open SSH to the world in real life
# - Restrict to your public IP /32 or VPN CIDR
########################################
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.bastion_host_sg.id

  # Source CIDR(s)
  cidr_blocks = [var.bastion_allowed_cidr]

  from_port = 22
  to_port   = 22
  protocol  = "tcp"
}

########################################
# EGRESS RULE (ALLOW ALL OUTBOUND)
########################################
resource "aws_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.bastion_host_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

########################################
# BASTION HOST (EC2 INSTANCE)
# - Public subnet (AZ-1 by default)
# - Public IP enabled (so you can SSH)
# - Key pair attached for SSH auth
########################################
resource "aws_instance" "bastion_host" {
  # AMI pulled from SSM Parameter Store
  ami           = data.aws_ssm_parameter.bastion_ami.value
  instance_type = var.instance_type
  key_name      = var.key_name

  # Place Bastion in the FIRST public subnet
  subnet_id = var.public_subnet_ids[0]

  # Attach Bastion Security Group
  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]

  # Ensure Public IP so you can SSH to it
  associate_public_ip_address = true

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-bastion-host"
  })
}