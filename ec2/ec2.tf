########################################
# EC2 MODULE
# - Bastion host in the public subnet
# - Private server instances across 2 private subnets
# - Security group rules for controlled SSH and internal VPC access
########################################

########################################
# REFERENCING BASTION HOST AMI
########################################
data "aws_ssm_parameter" "bastion_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

########################################
# CREATING SECURITY GROUP FOR BASTION HOST
########################################
resource "aws_security_group" "bastion_sg" {
  name        = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH from approved CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.bastion_allowed_cidr]
  }

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
# CREATING BASTION HOST INSTANCE
########################################
resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ssm_parameter.bastion_ami.value
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_az_1_id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-bastion-host"
  })
}

########################################
# CREATING SECURITY GROUP FOR PRIVATE SERVERS
########################################
resource "aws_security_group" "private_server_sg" {
  name        = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-server-sg"
  description = "Private server security group"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-server-sg"
  })
}

########################################
# CREATING INBOUND RULE TO ALLOW SSH FROM BASTION HOST
########################################
resource "aws_security_group_rule" "private_server_ssh_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_server_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
}

########################################
# CREATING INBOUND RULE TO ALLOW INTERNAL VPC TRAFFIC
########################################
resource "aws_security_group_rule" "private_server_internal_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.private_server_sg.id
  cidr_blocks       = [var.vpc_cidr_block]
}

########################################
# CREATING OUTBOUND RULE FOR PRIVATE SERVER SECURITY GROUP
########################################
resource "aws_security_group_rule" "private_server_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.private_server_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

########################################
# CREATING PRIVATE SERVER INSTANCE IN AZ 1
########################################
resource "aws_instance" "private_server_az_1" {
  ami                         = data.aws_ssm_parameter.bastion_ami.value
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.private_subnet_az_1_id
  vpc_security_group_ids      = [aws_security_group.private_server_sg.id]
  associate_public_ip_address = false

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-server-az-1"
  })
}

########################################
# CREATING PRIVATE SERVER INSTANCE IN AZ 2
########################################
resource "aws_instance" "private_server_az_2" {
  ami                         = data.aws_ssm_parameter.bastion_ami.value
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.private_subnet_az_2_id
  vpc_security_group_ids      = [aws_security_group.private_server_sg.id]
  associate_public_ip_address = false

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-server-az-2"
  })
}
