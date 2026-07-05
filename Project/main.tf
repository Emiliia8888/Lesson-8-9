provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
}

module "ecr" {
  source = "./modules/ecr"
}

module "eks" {
  source  = "./modules/eks"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = "aws"
  }
}

module "jenkins" {
  source     = "./modules/jenkins"
  depends_on = [module.eks]
}

module "argo_cd" {
  source     = "./modules/argo_cd"
  depends_on = [module.eks]
}
