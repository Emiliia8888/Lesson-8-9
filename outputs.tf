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

output "rds_instance_endpoint" {
  value       = module.rds.rds_instance_endpoint
  description = "RDS instance endpoint"
}


output "aurora_cluster_endpoint" {
  value       = module.rds.aurora_cluster_endpoint
  description = "Aurora cluster endpoint"
}


output "rds_security_group_id" {
  value       = module.rds.database_security_group_id
  description = "RDS security group ID"
}


output "rds_subnet_group_name" {
  value       = module.rds.db_subnet_group_name
  description = "RDS subnet group name"
}
