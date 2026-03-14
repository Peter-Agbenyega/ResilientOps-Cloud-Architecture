variable "vpc_id" {
  description = "VPC ID where the ALB resources will be created"
  type        = string
}

variable "public_subnet_az_2a_id" {
  description = "First public subnet ID used by the application load balancer"
  type        = string
}

variable "public_subnet_az_2b_id" {
  description = "Second public subnet ID used by the application load balancer"
  type        = string
}

variable "tags" {
  description = "Common tags applied to all ALB resources"
  type        = map(string)
}
