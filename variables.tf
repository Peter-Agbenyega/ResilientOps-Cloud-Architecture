variable "aws_region" {
  description = "AWS region to deploy infrastructure"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_cidr_blocks" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "private_cidr_blocks" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}

variable "database_cidr_blocks" {
  description = "Database subnet CIDR blocks"
  type        = list(string)
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "cloudnexus360-key-pairs"
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 3
}

variable "min_size" {
  type    = number
  default = 1
}

variable "extra_tags" {
  description = "Additional tags to merge with base project tags"
  type        = map(string)
  default     = {}
}

variable "bastion_allowed_cidr" {
  description = "CIDR block allowed to access bastion host"
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  type    = map(string)
  default = {}
}
