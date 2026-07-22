resource "aws_security_group" "db" {
  name        = "${var.environment}-${var.name}-db-sg"
  description = "Security group for database"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "db" {
  name       = "${var.environment}-${var.name}-subnet-group"
  subnet_ids = var.subnet_ids
}

# Parameter Group для звичайної RDS (прибрали статичний max_connections)
resource "aws_db_parameter_group" "rds" {
  count  = var.use_aurora ? 0 : 1
  name   = "${var.environment}-${var.name}-rds-pg-v2" # Змінили ім'я, щоб уникнути конфлікту зі старою групою
  family = var.parameter_group_family

  parameter {
    name  = "log_statement"
    value = "all"
  }
}

# Cluster Parameter Group для Aurora
resource "aws_rds_cluster_parameter_group" "aurora" {
  count  = var.use_aurora ? 1 : 0
  name   = "${var.environment}-${var.name}-aurora-pg-v2"
  family = var.parameter_group_family

  parameter {
    name  = "log_statement"
    value = "all"
  }
}
