variable "vpc_id" {
  description = "VPC ID where the autoscaling resources will be created"
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
  description = "Application load balancer target group ARN used by the autoscaling group"
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
  description = "AMI ID or SSM parameter path used for the application server instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the application servers"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name used for SSH access"
  type        = string
  default     = "cloudnexus360-key-pairs"
}

variable "max_size" {
  description = "Maximum size of the autoscaling group"
  type        = number
}

variable "min_size" {
  description = "Minimum size of the autoscaling group"
  type        = number
}

variable "desired_capacity" {
  description = "Desired capacity of the autoscaling group"
  type        = number
}

variable "tags" {
  description = "Common tags applied to all autoscaling resources"
  type        = map(string)
}
