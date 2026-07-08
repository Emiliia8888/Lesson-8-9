variable "create_argo_cd" {
  description = "Чи створювати модуль Argo CD"
  type        = bool
  default     = false
}

variable "region" {
  description = "Регіон AWS"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Середовище (dev/prod)"
  type        = string
  default     = "dev"
}

variable "db_password" {
  description = "Пароль для бази даних"
  type        = string
  sensitive   = true
}