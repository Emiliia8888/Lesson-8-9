output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "ID створеної VPC"
}

output "django_ecr_url" {
  value       = module.ecr.repository_url
  description = "URL для завантаження Docker-образу"
}

output "eks_cluster_name" {
  value       = module.eks.cluster_name
  description = "Назва Kubernetes кластера"
}