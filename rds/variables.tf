variable "vpc_id" {
  description = "VPC ID for database resources"
  type        = string
}

variable "db_subnet_az_1_id" {
  description = "Database subnet ID in AZ 1"
  type        = string
}

variable "db_subnet_az_2_id" {
  description = "Database subnet ID in AZ 2"
  type        = string
}

variable "app_security_group_id" {
  description = "Application security group ID allowed to connect to the database"
  type        = string
}

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_engine" {
  description = "Database engine for the RDS instance"
  type        = string

  validation {
    condition     = contains(["mysql", "postgres"], var.db_engine)
    error_message = "db_engine must be mysql or postgres."
  }
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage for the RDS instance"
  type        = number
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment for the RDS instance"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip the final snapshot on destroy"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
}
