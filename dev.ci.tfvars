aws_region = "us-east-1"
ami_id               = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
bastion_allowed_cidr = "209.217.213.62/32"
instance_type        = "t3.micro"
key_name             = "cloudnexus360-key-pairs"


vpc_cidr_block       = "10.0.0.0/16"

availability_zones   = ["us-east-1a", "us-east-1b"]
public_cidr_blocks   = ["10.0.0.0/24", "10.0.1.0/24"]
private_cidr_blocks  = ["10.0.10.0/24", "10.0.11.0/24"]
database_cidr_blocks = ["10.0.20.0/24", "10.0.21.0/24"]



tags = {
  project     = "terraform-enterprise-lab"
  application = "networking"
  environment = "dev"
  owner       = "peter"
  contact     = "admin@nexuscloud360.com"
}
