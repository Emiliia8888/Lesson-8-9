terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }
}

provider "aws" {
  region = var.region
}


#provider "kubernetes" {
#  host                   = module.eks.cluster_endpoint
#  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

#  exec {
#    api_version = "client.authentication.k8s.io/v1beta1"

#    command = "aws"

#    args = [
#      "eks",
#      "get-token",
#      "--cluster-name",
#      module.eks.cluster_name
#    ]
#  }
#}


module "vpc" {
  source = "./modules/vpc"
}


module "ecr" {
  source = "./modules/ecr"
}


module "eks" {
  source = "./modules/eks"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  depends_on = [
    module.vpc
  ]
}


#module "jenkins" {
#  source = "./modules/jenkins"

#  cluster_name      = module.eks.cluster_name
#  oidc_provider_arn = module.eks.oidc_provider_arn
#  oidc_provider_url = module.eks.oidc_provider

#  depends_on = [
#    module.eks
#  ]
#}
