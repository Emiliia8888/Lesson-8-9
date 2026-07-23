resource "aws_db_subnet_group" "this" {
  name       = "django-rds-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "django-rds-subnet-group"
  }
}


resource "aws_security_group" "this" {
  name        = "django-rds-security-group"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
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


resource "aws_db_parameter_group" "this" {
  name   = "django-rds-parameter-group"
  family = "postgres16"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  tags = {
    Name = "django-rds-parameter-group"
  }
}
