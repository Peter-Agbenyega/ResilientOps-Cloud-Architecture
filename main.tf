terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "peter-terraform-state-backend-001"
    key            = "resilientops-cloud-architecture/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "peter-terraform-state-locks-001"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

# IAM module
module "iam" {
  source = "./iam"

  tags = local.merged_tags
}

# VPC module
module "vpc" {
  source = "./vpc"

  vpc_cidr_block       = var.vpc_cidr_block
  availability_zones   = var.availability_zones
  public_cidr_blocks   = var.public_cidr_blocks
  private_cidr_blocks  = var.private_cidr_blocks
  database_cidr_blocks = var.database_cidr_blocks

  tags = local.merged_tags
}

# EC2 module for bastion and private hosts
module "ec2" {
  source = "./ec2"

  vpc_id                 = module.vpc.vpc_id
  public_subnet_az_1_id  = module.vpc.public_subnet_az_1_id
  private_subnet_az_1_id = module.vpc.private_subnet_az_1_id
  private_subnet_az_2_id = module.vpc.private_subnet_az_2_id
  vpc_cidr_block         = module.vpc.vpc_cidr_block

  tags                 = local.merged_tags
  bastion_allowed_cidr = var.bastion_allowed_cidr

  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
}

# ALB MODULE
# ALB MODULE
# ALB MODULE
module "alb" {
  source = "./alb"

  vpc_id                 = module.vpc.vpc_id
  public_subnet_az_2a_id = module.vpc.public_subnet_az_2a_id
  public_subnet_az_2b_id = module.vpc.public_subnet_az_2b_id

  tags = local.merged_tags
}
# AUTO SCALING MODULE
module "auto_scaling" {
  source = "./auto-scaling"

  vpc_id                 = module.vpc.vpc_id
  private_subnet_az_1_id = module.vpc.private_subnet_az_1_id
  private_subnet_az_2_id = module.vpc.private_subnet_az_2_id

  jupiter_app_tg_arn        = module.alb.jupiter_app_tg_arn
  alb_security_group_id     = module.alb.security_group_id
  bastion_security_group_id = module.ec2.bastion_sg_id

  ami_id           = var.ami_id
  instance_type    = var.instance_type
  key_name         = var.key_name
  max_size         = var.max_size
  min_size         = var.min_size
  desired_capacity = var.desired_capacity

  tags = local.merged_tags
}

# RDS module
module "rds" {
  source = "./rds"

  vpc_id                = module.vpc.vpc_id
  db_subnet_az_1_id     = module.vpc.db_subnet_az_1_id
  db_subnet_az_2_id     = module.vpc.db_subnet_az_2_id
  app_security_group_id = module.auto_scaling.security_group_id

  db_identifier       = var.db_identifier
  db_name             = var.db_name
  db_engine           = var.db_engine
  db_engine_version   = var.db_engine_version
  db_instance_class   = var.db_instance_class
  allocated_storage   = var.db_allocated_storage
  db_username         = var.db_username
  db_password         = var.db_password
  multi_az            = var.db_multi_az
  skip_final_snapshot = var.db_skip_final_snapshot

  tags = local.merged_tags
}
