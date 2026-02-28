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
