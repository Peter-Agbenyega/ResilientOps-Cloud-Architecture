variable "ami_id" {
  description = "AMI SSM path or AMI ID for EC2 instances"
  type        = string
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}


variable "vpc_cidr_block" {
  type = string
}

variable "public_cidr_blocks" {
  type = list(string)
}

variable "private_cidr_blocks" {
  type = list(string)
}

variable "database_cidr_blocks" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "bastion_allowed_cidr" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "extra_tags" {
  description = "Additional tags to merge with default project tags"
  type        = map(string)
  default     = {}
}