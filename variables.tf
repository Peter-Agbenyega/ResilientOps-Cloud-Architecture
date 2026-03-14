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

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_engine" {
  description = "Database engine for the RDS instance"
  type        = string
}

variable "db_engine_version" {
  description = "Database engine version for the RDS instance"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage in gibibytes for the RDS instance"
  type        = number
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "db_multi_az" {
  description = "Enable Multi-AZ deployment for the RDS instance"
  type        = bool
  default     = false
}

variable "db_skip_final_snapshot" {
  description = "Skip the final snapshot when the RDS instance is destroyed"
  type        = bool
  default     = true
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
