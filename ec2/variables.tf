variable "vpc_id" {
  type = string
}

variable "public_subnet_az_1_id" {
  type = string
}

variable "private_subnet_az_1_id" {
  type = string
}

variable "private_subnet_az_2_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "bastion_allowed_cidr" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}