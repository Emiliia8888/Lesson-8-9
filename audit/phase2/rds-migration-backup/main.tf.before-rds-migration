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

module "monitoring" {
  source = "./modules/monitoring"

  depends_on = [
    module.eks
  ]
}

module "jenkins" {
  source = "./modules/jenkins"

  oidc_issuer = module.eks.cluster_oidc_issuer

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

  name        = var.project_name
  environment = var.environment

  vpc_id = "vpc-0b54945bf169ee3e3"

  subnet_ids = [
    "subnet-09ee881e76fc49338",
    "subnet-0dc38866a0ae9363a",
    "subnet-0f594a6bfc3a96055"
  ]

  db_name  = "django"
  username = "django_admin"
  password = var.db_password

  engine_version         = "16"
  instance_class         = "db.t3.micro"
  parameter_group_family = "postgres16"

  depends_on = [
    module.vpc
  ]
}

module "ecr" {
  source = "./modules/ecr"

  environment = var.environment

  repository_name = "django-app-gitops"
}

module "s3_backend" {
  source = "./modules/s3-backend"

  bucket_name = "emiliia-ft-state-lesson-99"
  table_name  = "terraform-lock"
}

resource "kubernetes_storage_class_v1" "gp3" {
  metadata {
    name = "gp3"

    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner = "ebs.csi.aws.com"

  reclaim_policy         = "Delete"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true

  parameters = {
    type   = "gp3"
    fsType = "ext4"
  }
}

resource "aws_secretsmanager_secret" "django_postgresql" {
  name = "django/postgresql"

  recovery_window_in_days = 30
}

resource "aws_secretsmanager_secret_version" "django_postgresql" {
  secret_id      = aws_secretsmanager_secret.django_postgresql.id
  version_stages = ["AWSCURRENT"]

  lifecycle {
    ignore_changes = [
      secret_string,
      secret_binary,
      secret_string_wo,
    ]
  }
}

module "aws_load_balancer_controller" {
  source = "./modules/aws_load_balancer_controller"

  cluster_name = module.eks.cluster_name
  vpc_id       = module.vpc.vpc_id
  oidc_issuer  = module.eks.cluster_oidc_issuer

  depends_on = [
    module.eks,
    module.vpc
  ]
}
