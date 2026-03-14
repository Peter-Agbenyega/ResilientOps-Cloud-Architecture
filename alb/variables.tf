variable "vpc_id" {
  description = "VPC ID for ALB resources"
  type        = string
}

variable "public_subnet_az_2a_id" {
  description = "First public subnet ID used by the ALB"
  type        = string
}

variable "public_subnet_az_2b_id" {
  description = "Second public subnet ID used by the ALB"
  type        = string
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
}
