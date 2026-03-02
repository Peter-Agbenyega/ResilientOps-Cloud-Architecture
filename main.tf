terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # ----------------------------------------
  # REMOTE STATE (S3) + STATE LOCKING (DynamoDB)
  # NOTE: Backend does NOT support var.* or locals.*
  # Replace the placeholders below with YOUR real values.
  # ----------------------------------------
  backend "s3" {
    bucket         = "REPLACE_ME-terraform-state-bucket"
    key            = "REPLACE_ME/resilientops-cloud-architecture/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "REPLACE_ME-terraform-lock-table"
    encrypt        = true
  }
}

# ----------------------------------------
# AWS PROVIDER
# ----------------------------------------
provider "aws" {
  region = var.aws_region
}


terraform {
  backend "s3" {
    bucket         = "peter-terraform-state-backend-001"
    key            = "resilientops-cloud-architecture/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "peter-terraform-state-locks-001"
    encrypt        = true
  }
}
# ----------------------------------------
# VPC MODULE
# ----------------------------------------
module "vpc" {
  source = "./vpc"

  vpc_cidr_block       = var.vpc_cidr_block
  availability_zones   = var.availability_zones
  public_cidr_blocks   = var.public_cidr_blocks
  private_cidr_blocks  = var.private_cidr_blocks
  database_cidr_blocks = var.database_cidr_blocks

  # Class convention: tags passed into modules
  tags = local.merged_tags
}

# ----------------------------------------
# EC2 MODULE (Bastion)
# ----------------------------------------
module "ec2" {
  source = "./ec2"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

  tags                 = local.merged_tags
  bastion_allowed_cidr = var.bastion_allowed_cidr

  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
}