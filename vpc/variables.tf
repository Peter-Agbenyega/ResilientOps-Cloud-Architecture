variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "database_cidr_blocks" {
  description = "CIDR blocks for database-ready subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability Zones used for multi-AZ placement"
  type        = list(string)
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
}
