variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS регіон"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Назва середовища"
}

variable "project_name" {
  type        = string
  default     = "django-infra"
  description = "Назва проєкту"
}