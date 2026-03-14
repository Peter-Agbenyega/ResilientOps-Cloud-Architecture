variable "vpc_id" {
  description = "VPC ID where the EC2 resources will be created"
  type        = string
}

variable "public_subnet_az_1_id" {
  description = "Public subnet ID used for the bastion host"
  type        = string
}

variable "private_subnet_az_1_id" {
  description = "Private subnet ID used for the private server in AZ 1"
  type        = string
}

variable "private_subnet_az_2_id" {
  description = "Private subnet ID used for the private server in AZ 2"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC for internal traffic rules"
  type        = string
}

variable "tags" {
  description = "Common tags applied to all EC2 resources"
  type        = map(string)
}

variable "bastion_allowed_cidr" {
  description = "CIDR block allowed to SSH into the bastion host"
  type        = string
}

variable "ami_id" {
  description = "AMI identifier retained for interface consistency with the root module"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type used for the bastion host and private servers"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name used for SSH access"
  type        = string
}
