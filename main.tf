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

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"

      command = "aws"

      args = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks.cluster_name
      ]
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"

    command = "aws"

    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_name
    ]
  }
}


module "vpc" {
  source = "./modules/vpc"
}


module "rds" {
  source = "./modules/rds"

  vpc_id = module.vpc.vpc_id

  private_subnets = module.vpc.private_subnets

  use_aurora = false

  engine         = "postgres"
  engine_version = "16"
  instance_class = "db.t3.micro"
  multi_az       = false

  master_password = "ChangeMe12345!"
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


module "jenkins" {
  source = "./modules/jenkins"

  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider

  depends_on = [
    module.eks
  ]
}



module "argo_cd" {
  source = "./modules/argo_cd"

  depends_on = [
    module.eks
  ]
}

module "aws_load_balancer_controller" {

  source = "./modules/aws_load_balancer_controller"

  cluster_name = module.eks.cluster_name

  oidc_provider_arn = module.eks.oidc_provider_arn

  oidc_provider_url = module.eks.oidc_provider

  depends_on = [
    module.eks
  ]
}
