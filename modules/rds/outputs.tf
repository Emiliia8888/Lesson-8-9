output "rds_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = var.use_aurora ? null : aws_db_instance.this[0].endpoint
}


output "aurora_cluster_endpoint" {
  description = "Aurora cluster endpoint"
  value       = var.use_aurora ? aws_rds_cluster.this[0].endpoint : null
}


output "database_security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.this.id
}


output "db_subnet_group_name" {
  description = "RDS subnet group name"
  value       = aws_db_subnet_group.this.name
}
