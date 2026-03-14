variable "vpc_cidr_block" {
  description = "CIDR block for the main VPC"
  type        = string
}

variable "public_cidr_blocks" {
  description = "CIDR blocks for the public subnets in AZ 1 and AZ 2"
  type        = list(string)
}

variable "private_cidr_blocks" {
  description = "CIDR blocks for the private subnets in AZ 1 and AZ 2"
  type        = list(string)
}

variable "database_cidr_blocks" {
  description = "CIDR blocks for the database subnets in AZ 1 and AZ 2"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability Zones used to place resources across AZ 1 and AZ 2"
  type        = list(string)
}

variable "tags" {
  description = "Common tags applied to all VPC resources"
  type        = map(string)
}
