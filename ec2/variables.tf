variable "vpc_id" {
  description = "VPC ID for EC2 resources"
  type        = string
}

variable "public_subnet_az_1_id" {
  description = "Public subnet ID for the bastion host"
  type        = string
}

variable "private_subnet_az_1_id" {
  description = "Private subnet ID for the first private host"
  type        = string
}

variable "private_subnet_az_2_id" {
  description = "Private subnet ID for the second private host"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the parent VPC"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
}

variable "bastion_allowed_cidr" {
  description = "CIDR allowed to SSH into the bastion host"
  type        = string
}

variable "ami_id" {
  description = "AMI identifier retained for interface consistency with the root module"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for bastion and private hosts"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name used for SSH access"
  type        = string
}
