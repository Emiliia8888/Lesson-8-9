output "repository_url" {
  value       = aws_ecr_repository.django_app.repository_url
  description = "The URL of the ECR repository"
}
