resource "aws_security_group" "db" {
  name        = "django-rds-security-group"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "PostgreSQL from VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "django-rds-security-group"
  }
}

resource "aws_db_subnet_group" "db" {
  name = "django-rds-subnet-group"
  subnet_ids = [
    "subnet-0dc38866a0ae9363a",
    "subnet-09ee881e76fc49338",
    "subnet-0f594a6bfc3a96055",
  ]

  tags = {
    Name = "django-rds-subnet-group"
  }
}

resource "aws_db_parameter_group" "rds" {
  count = var.use_aurora ? 0 : 1

  name   = "django-rds-parameter-group"
  family = "postgres16"

  parameter {
    name         = "work_mem"
    value        = "4096"
    apply_method = "immediate"
  }

  parameter {
    name         = "log_statement"
    value        = "all"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_connections"
    value        = "200"
    apply_method = "pending-reboot"
  }

  tags = {
    Name = "django-rds-parameter-group"
  }
}

resource "aws_rds_cluster_parameter_group" "aurora" {
  count = var.use_aurora ? 1 : 0

  name   = "${var.environment}-${var.name}-aurora-pg-v2"
  family = var.parameter_group_family

  parameter {
    name  = "log_statement"
    value = "all"
  }
}
