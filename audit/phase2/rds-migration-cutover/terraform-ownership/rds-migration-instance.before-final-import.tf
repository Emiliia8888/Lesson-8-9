resource "aws_db_instance" "rds_migration" {
  identifier = "django-rds-migration"

  snapshot_identifier = "django-rds-migration-encrypted-2026-08-16"

  instance_class    = "db.t3.micro"
  storage_encrypted = true

  db_subnet_group_name   = aws_db_subnet_group.rds_migration.name
  vpc_security_group_ids = [aws_security_group.rds_migration.id]

  parameter_group_name = "django-rds-parameter-group"

  backup_retention_period = 7
  deletion_protection     = true
  skip_final_snapshot     = false

  tags = {
    Name = "django-rds-migration"
  }

  lifecycle {
    prevent_destroy = true
  }
}
