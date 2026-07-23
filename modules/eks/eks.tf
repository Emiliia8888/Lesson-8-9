module "aws_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "django-gitops-cluster"
  cluster_version = "1.30"

  cluster_endpoint_public_access = true

  vpc_id     = var.vpc_id
  subnet_ids = var.subnets


  #
  # Existing encryption
  #
  create_kms_key = false

  cluster_encryption_config = {
    resources = ["secrets"]

    provider_key_arn = "arn:aws:kms:eu-central-1:034255117140:key/3eda186b-e46d-47a0-af4f-aef35bd49bab"
  }


  #
  # Existing security groups
  #
  create_cluster_security_group = false
  create_node_security_group    = false

  cluster_security_group_id = "sg-075ac93fc2d305bee"
  node_security_group_id    = "sg-0b7fbac763305f57e"


  #
  # Existing node group
  #
  eks_managed_node_groups = {
    main = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = [
        "t3.medium"
      ]

      vpc_security_group_ids = [
        "sg-0b7fbac763305f57e"
      ]
    }
  }


  enable_cluster_creator_admin_permissions = true
}
