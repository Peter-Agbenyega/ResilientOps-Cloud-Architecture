variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "bastion_allowed_cidr" {
  type        = string
  description = "CIDR allowed to SSH into the bastion host (use your public IP /32 in real life)"
}

variable "ami_id" {
  type        = string
  description = "SSM AMI parameter path for Amazon Linux (not raw ami-xxxx)"
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "tags" {
  type = map(string)
}