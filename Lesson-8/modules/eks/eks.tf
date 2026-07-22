module "aws_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "django-gitops-cluster"
  cluster_version = "1.30"

  cluster_endpoint_public_access = true

  vpc_id     = var.vpc_id
  subnet_ids = var.subnets

  # Enable IAM Roles for Service Accounts (IRSA)
  enable_irsa = true

  eks_managed_node_groups = {
    main = {
      min_size       = 1
      max_size       = 3
      desired_size   = 2

      instance_types = [
        "t3.medium"
      ]
    }
  }

  enable_cluster_creator_admin_permissions = true
}