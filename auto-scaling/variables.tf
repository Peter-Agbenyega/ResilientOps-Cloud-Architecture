variable "vpc_id" {
  description = "VPC ID for autoscaling resources"
  type        = string
}

variable "private_subnet_az_1_id" {
  description = "First private subnet ID used by the autoscaling group"
  type        = string
}

variable "private_subnet_az_2_id" {
  description = "Second private subnet ID used by the autoscaling group"
  type        = string
}

variable "jupiter_app_tg_arn" {
  description = "Target group ARN used by the autoscaling group"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID of the application load balancer"
  type        = string
}

variable "bastion_security_group_id" {
  description = "Security group ID of the bastion host"
  type        = string
}

variable "ami_id" {
  description = "AMI ID or SSM parameter path used for application instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for application servers"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name used for SSH access"
  type        = string
  default     = "cloudnexus360-key-pairs"
}

variable "max_size" {
  description = "Maximum autoscaling group size"
  type        = number
}

variable "min_size" {
  description = "Minimum autoscaling group size"
  type        = number
}

variable "desired_capacity" {
  description = "Desired autoscaling group size"
  type        = number
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
}
