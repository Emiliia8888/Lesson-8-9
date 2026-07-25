terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
    }

    helm = {
      source = "hashicorp/helm"
    }
  }
}


provider "aws" {
  region = var.region
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
      module.eks.cluster_name,
      "--region",
      var.region
    ]
  }
}


provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"

      command = "aws"

      args = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks.cluster_name,
        "--region",
        var.region
      ]
    }
  }
}


module "vpc" {
  source = "./modules/vpc"

  environment = var.environment
}


module "eks" {
  source = "./modules/eks"

  environment = var.environment

  subnet_ids = module.vpc.private_subnets

  depends_on = [
    module.vpc
  ]
}


module "jenkins" {
  source = "./modules/jenkins"

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


module "rds" {
  source = "./modules/rds"

  name = var.project_name

  environment = var.environment

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.private_subnets

  db_name = "django_db"

  username = "postgres"

  password = "REDACTED-TERRAFORM-DB-PASSWORD"

  depends_on = [
    module.vpc
  ]
}


module "ecr" {
  source = "./modules/ecr"

  environment = var.environment

  repository_name = "django-app"
}

module "s3_backend" {
  source = "./modules/s3-backend"

  bucket_name = "emiliia-ft-state-lesson-99"
  table_name  = "terraform-lock"
}
