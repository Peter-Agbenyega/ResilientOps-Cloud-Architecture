variable "vpc_id" {
  description = "VPC ID for autoscaling resources"
  type        = string
}

variable "public_subnet_az_2a_id" {
  description = "First subnet ID used by the autoscaling group"
  type        = string
}

variable "public_subnet_az_2b_id" {
  description = "Second subnet ID used by the autoscaling group"
  type        = string
}

variable "jupiter_app_tg_arn" {
  description = "Target group ARN used by the autoscaling group"
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
