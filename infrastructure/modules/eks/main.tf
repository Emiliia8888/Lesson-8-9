module "eks" {

  source = "terraform-aws-modules/eks/aws"

  version = "20.8.5"


  cluster_name = "eks-${var.environment}"

  cluster_version = "1.30"


  subnet_ids = var.subnet_ids


  cluster_endpoint_public_access = true


  enable_cluster_creator_admin_permissions = true


  eks_managed_node_groups = {

    default = {

      min_size     = 1
      max_size     = 2
      desired_size = 1


      instance_types = [
        "t3.medium"
      ]

    }

  }


  tags = {

    Environment = var.environment

  }

}
