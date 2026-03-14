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
  description = "AMI ID or SSM parameter path used by EC2 instances and the launch template"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type used across bastion, private hosts, and application instances"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 key pair name for SSH-based access where applicable"
  type        = string
  default     = "cloudnexus360-key-pairs"
}

variable "desired_capacity" {
  description = "Desired capacity for the autoscaling group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum autoscaling group size"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum autoscaling group size"
  type        = number
  default     = 1
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
  description = "Base tags applied to resources and used by naming conventions"
  type        = map(string)
  default     = {}
}
