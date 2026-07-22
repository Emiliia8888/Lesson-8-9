variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS region"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment name"
}

variable "project_name" {
  type        = string
  default     = "django-infra"
  description = "Project name"
}

variable "cluster_name" {
  type        = string
  default     = "dev-eks-cluster"
  description = "EKS cluster name"
}

variable "db_password" {
  description = "Пароль для бази даних"
  type        = string
  sensitive   = true
}
