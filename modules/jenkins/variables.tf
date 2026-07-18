variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}


variable "oidc_provider_arn" {
  description = "EKS OIDC provider ARN used for IRSA"
  type        = string
}


variable "oidc_provider_url" {
  description = "EKS OIDC provider URL used for IRSA"
  type        = string
}


variable "namespace" {
  description = "Namespace for Jenkins"
  type        = string
  default     = "jenkins"
}


variable "chart_version" {
  description = "Jenkins Helm chart version"
  type        = string
  default     = "5.8.63"
}
