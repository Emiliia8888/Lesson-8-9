resource "aws_db_instance" "this" {
  count = var.use_aurora ? 0 : 1

  identifier = "django-rds-instance"

  engine         = "postgres"
  engine_version = "16"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name = "django"

  username = "django_admin"
  password = var.password

  lifecycle {
    ignore_changes = [
      password,
    ]
  }

  port = var.db_port

  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.db.id]

  parameter_group_name = aws_db_parameter_group.rds[0].name

  backup_retention_period = 7
  deletion_protection     = true
  skip_final_snapshot     = false

  tags = {
    Name = "django-rds-instance"
  }
}
