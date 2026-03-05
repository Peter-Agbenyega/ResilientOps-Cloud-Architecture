########################################
# EC2 MODULE
# - Bastion Host (public subnet)
# - SSH restricted by allowed CIDR
########################################

########################################
# DATA SOURCE: AMI FROM SSM PARAMETER STORE
# NOTE:
# - We pass an SSM path like:
#   /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64
# - Terraform will fetch the latest AMI ID automatically.
########################################
data "aws_ssm_parameter" "bastion_ami" {
  name = var.ami_id
}

########################################
# SECURITY GROUP (BASTION HOST)
# - Ingress: SSH (22) ONLY from allowed CIDR
# - Egress: Allow all outbound traffic
#
# Mentor-style note:
# At work, you NEVER open SSH to the world.
# You restrict it to a corporate VPN CIDR or your public IP /32.
########################################
resource "aws_security_group" "bastion_sg" {
  name        = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  ########################################
  # INGRESS (SSH)
  ########################################
  ingress {
    description = "Allow SSH from approved CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.bastion_allowed_cidr]
  }

  ########################################
  # EGRESS (ALLOW ALL OUTBOUND)
  ########################################
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-bastion-sg"
  })
}

########################################
# BASTION HOST (EC2 INSTANCE)
# - Public subnet (first public subnet by default)
# - Public IP enabled (so you can SSH)
# - Key pair attached for SSH auth
########################################
resource "aws_instance" "bastion_host" {
  ########################################
  # AMI pulled from SSM Parameter Store
  ########################################
  ami           = data.aws_ssm_parameter.bastion_ami.value
  instance_type = var.instance_type
  key_name      = var.key_name

  ########################################
  # Place Bastion in FIRST public subnet
  ########################################
  subnet_id = var.public_subnet_ids[0]

  ########################################
  # Attach Bastion Security Group
  ########################################
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  ########################################
  # Ensure Public IP so you can SSH
  ########################################
  associate_public_ip_address = true

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-bastion-host"
  })
}