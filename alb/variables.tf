variable "vpc_id" {
  description = "VPC ID for ALB resources"
  type        = string
}

variable "public_subnet_az_2a_id" {
  description = "Public subnet ID in AZ2A"
  type        = string
}

variable "public_subnet_az_2b_id" {
  description = "Public subnet ID in AZ2B"
  type        = string
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
}
variable "ssl_certificate_arn" {
  description = "ARN of the ACM SSL certificate"
  type        = string
}

variable "ssl_policy" {
  type = string
}

