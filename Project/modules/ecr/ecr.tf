resource "aws_ecr_repository" "django_app" {
  name                 = "django-app-gitops"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
