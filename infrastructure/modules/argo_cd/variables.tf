variable "environment" {
  description = "Середовище (наприклад, dev або prod)"
  type        = string
}

variable "cluster_name" {
  description = "Назва кластера EKS"
  type        = string
}