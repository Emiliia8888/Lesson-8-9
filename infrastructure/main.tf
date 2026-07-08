module "vpc" {
  source      = "./modules/vpc"
  environment = "dev"
}

module "eks" {
  source      = "./modules/eks"
  environment = "dev"
  subnet_ids  = module.vpc.private_subnets
}

module "argo_cd" {
  source       = "./modules/argo_cd"
  environment  = "dev"
  cluster_name = module.eks.cluster_name
}
