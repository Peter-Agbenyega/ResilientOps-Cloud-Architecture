########################################
# RDS MODULE
# - DB subnet group across database subnets
# - Security group for database access
# - Private RDS instance for application workloads
########################################

# SETTING DATABASE PORT BASED ON ENGINE
locals {
  db_port = {
    mysql    = 3306
    postgres = 5432
  }[var.db_engine]
}

########################################
# CREATING DB SUBNET GROUP
########################################
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-subnet-group"
  subnet_ids = [var.db_subnet_az_1_id, var.db_subnet_az_2_id]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-subnet-group"
  })
}

########################################
# CREATING RDS SECURITY GROUP
########################################
resource "aws_security_group" "rds_sg" {
  name        = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-rds-sg"
  description = "Security group for the RDS instance"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-rds-sg"
  })
}

########################################
# CREATING INBOUND RULE FOR RDS SECURITY GROUP
########################################
resource "aws_vpc_security_group_ingress_rule" "allow_db_access_from_app_server" {
  security_group_id            = aws_security_group.rds_sg.id
  referenced_security_group_id = var.app_security_group_id
  from_port                    = local.db_port
  ip_protocol                  = "tcp"
  to_port                      = local.db_port
}

########################################
# CREATING OUTBOUND RULE FOR RDS SECURITY GROUP
########################################
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_for_rds" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

########################################
# CREATING RELATIONAL DATABASE INSTANCE
########################################
resource "aws_db_instance" "main" {
  identifier             = var.db_identifier
  db_name                = var.db_name
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  allocated_storage      = var.allocated_storage
  username               = var.db_username
  password               = var.db_password
  port                   = local.db_port
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible       = false
  multi_az                  = var.multi_az
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.db_identifier}-final-snapshot"

  apply_immediately       = true
  backup_retention_period = 0
  deletion_protection     = false
  storage_type            = "gp3"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-rds"
  })
}
