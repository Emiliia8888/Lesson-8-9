resource "aws_db_instance" "this" {
  count = var.use_aurora ? 0 : 1

  identifier        = "${var.environment}-${var.name}-rds"
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = var.db_port

  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.db.id]
  parameter_group_name   = aws_db_parameter_group.rds[0].name

  skip_final_snapshot = true

  lifecycle {
    ignore_changes = [
      password
    ]
  }
}
