terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
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

module "rds" {
  source      = "./modules/rds"
  environment = var.environment
  name        = "django-db"

  use_aurora = false

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  db_name  = "django_db"
  username = "postgres"
  password = var.db_password
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "emiliia-terraform-state-lesson-5"
  table_name  = "terraform-lock-table"
}
