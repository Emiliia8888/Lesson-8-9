resource "aws_security_group" "rds_migration" {
  name        = "django-rds-migration-security-group"
  description = "Temporary target RDS security group for migration"
  vpc_id      = "vpc-0a193c45e151d961d"

  ingress {
    description     = "PostgreSQL from EKS"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["sg-01ba2c0d2024f79b7"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "django-rds-migration-security-group"
  }
}
