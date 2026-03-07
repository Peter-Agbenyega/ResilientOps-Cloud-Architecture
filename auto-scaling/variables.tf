variable "vpc_id" {
  type = string
}

variable "public_subnet_az2a_id" {
  type = string
}

variable "public_subnet_az2b_id" {
  type = string
}

variable "jupiter_app_tg_arn" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type    = string
  default = "cloudnexus360-key-pairs"
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "tags" {
  type = map(string)
}