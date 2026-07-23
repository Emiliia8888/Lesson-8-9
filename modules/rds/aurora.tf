resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier = "django-aurora-cluster"

  engine         = var.engine
  engine_version = var.engine_version

  database_name   = var.database_name
  master_username = var.master_username
  master_password = var.master_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  db_cluster_parameter_group_name = aws_db_parameter_group.this.name

  skip_final_snapshot = true

  tags = {
    Name = "django-aurora-cluster"
  }
}


resource "aws_rds_cluster_instance" "writer" {
  count = var.use_aurora ? 1 : 0

  identifier = "django-aurora-writer"

  cluster_identifier = aws_rds_cluster.this[0].id

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  db_subnet_group_name = aws_db_subnet_group.this.name

  publicly_accessible = false

  tags = {
    Name = "django-aurora-writer"
  }
}
