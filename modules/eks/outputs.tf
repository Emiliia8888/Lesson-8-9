output "cluster_name" {
  value = module.aws_eks.cluster_name
}

output "cluster_endpoint" {
  value = module.aws_eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.aws_eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  value = module.aws_eks.oidc_provider_arn
}

output "oidc_provider" {
  value = module.aws_eks.oidc_provider
}
