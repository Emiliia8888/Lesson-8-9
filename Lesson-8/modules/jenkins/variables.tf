variable "namespace" {

  description = "Namespace for Jenkins"

  type = string

  default = "jenkins"

}


variable "chart_version" {

  description = "Jenkins Helm chart version"

  type = string

  default = "5.8.63"

}


variable "cluster_endpoint" {

  description = "EKS cluster endpoint dependency"

  type = any

}