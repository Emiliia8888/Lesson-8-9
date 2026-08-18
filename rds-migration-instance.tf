resource "aws_db_instance" "rds_migration" {
  identifier = "django-rds-migration-final"

  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp3"

  storage_encrypted = true

  db_subnet_group_name   = aws_db_subnet_group.rds_migration.name
  vpc_security_group_ids = [aws_security_group.rds_migration.id]

  backup_retention_period = 7
  deletion_protection     = true

  auto_minor_version_upgrade = false
  copy_tags_to_snapshot      = true
  skip_final_snapshot        = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "django-rds-instance"
  }
}
