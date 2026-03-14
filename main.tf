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

# VPC MODULE
module "vpc" {
  source = "./vpc"

  vpc_cidr_block       = var.vpc_cidr_block
  availability_zones   = var.availability_zones
  public_cidr_blocks   = var.public_cidr_blocks
  private_cidr_blocks  = var.private_cidr_blocks
  database_cidr_blocks = var.database_cidr_blocks

  tags = local.merged_tags
}

# EC2 MODULE (Bastion)
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
  public_subnet_az_2a_id = module.vpc.public_subnet_az_2a_id
  public_subnet_az_2b_id = module.vpc.public_subnet_az_2b_id

  jupiter_app_tg_arn = module.alb.jupiter_app_tg_arn

  ami_id           = var.ami_id
  instance_type    = var.instance_type
  key_name         = var.key_name
  max_size         = var.max_size
  min_size         = var.min_size
  desired_capacity = var.desired_capacity

  tags = local.merged_tags
}
