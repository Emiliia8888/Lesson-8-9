resource "aws_db_instance" "this" {
  count = var.use_aurora ? 0 : 1

  identifier = "django-rds-instance"

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.database_name
  username = var.master_username
  password = var.master_password

  multi_az = var.multi_az

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  parameter_group_name   = aws_db_parameter_group.this.name

  publicly_accessible = false

  skip_final_snapshot = true

  tags = {
    Name = "django-rds-instance"
  }
}
