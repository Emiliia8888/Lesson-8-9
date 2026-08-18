resource "aws_db_subnet_group" "rds_migration" {
  name = "django-rds-migration-subnet-group"

  subnet_ids = [
    "subnet-0c8ba5309ccef069a",
    "subnet-0fff89a05a16721f8",
  ]

  tags = {
    Name = "django-rds-migration-subnet-group"
  }
}
