variable "vpc_id" {
  description = "VPC ID for RDS security group"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs for RDS subnet group"
  type        = list(string)
}

variable "use_aurora" {
  description = "Create Aurora cluster instead of standalone RDS instance"
  type        = bool
  default     = false
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "16"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "database_name" {
  description = "Initial database name"
  type        = string
  default     = "django"
}

variable "master_username" {
  description = "Master database username"
  type        = string
  default     = "django_admin"
}

variable "master_password" {
  description = "Master database password"
  type        = string
  sensitive   = true
}
