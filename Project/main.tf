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


provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)

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
  source      = "./modules/vpc"
  environment = var.environment
}


module "ecr" {
  source          = "./modules/ecr"
  environment     = var.environment
  repository_name = "django-app"
}


module "eks" {
  source      = "./modules/eks"
  environment = var.environment
  subnet_ids  = module.vpc.private_subnets
}


module "rds" {
  source      = "./modules/rds"
  environment = var.environment
  name        = "django-db"

  use_aurora = false

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  db_name  = "django_db"
  username = "postgres"
  password = "REDACTED-TERRAFORM-DB-PASSWORD"
}


module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "emiliia-terraform-state-lesson-5"
  table_name  = "terraform-lock-table"
}


module "jenkins" {
  source = "./modules/jenkins"

  depends_on = [
    module.eks
  ]
}