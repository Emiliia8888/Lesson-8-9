resource "aws_eks_cluster" "this" {
  name     = "${var.environment}-eks-cluster"
  role_arn = aws_iam_role.cluster.arn

  bootstrap_self_managed_addons = false

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
  ]

  encryption_config {
    resources = ["secrets"]

    provider {
      key_arn = "arn:aws:kms:eu-central-1:034255117140:key/04d02d5e-5057-4698-80d0-d6ea44874a71"
    }
  }

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = {
    "terraform-aws-modules" = "eks"
  }

  depends_on = [aws_iam_role_policy_attachment.cluster_policy]
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.environment}-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 6
    min_size     = 2
  }

  instance_types = ["t3.medium"]

  tags = {
    Name = "${var.environment}-node-group"
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.registry_policy,
  ]
}

resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/aws/eks/${var.environment}-eks-cluster/cluster"
  retention_in_days = 90

  tags = {
    Name = "/aws/eks/${var.environment}-eks-cluster/cluster"
  }
}

resource "aws_iam_role" "ebs_csi_driver" {
  name = "ebs-csi-driver-django-gitops-cluster"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = "arn:aws:iam::034255117140:oidc-provider/oidc.eks.eu-central-1.amazonaws.com/id/09C314552F181D184EF107C6FB70BD9C"
        }
        Condition = {
          StringEquals = {
            "oidc.eks.eu-central-1.amazonaws.com/id/09C314552F181D184EF107C6FB70BD9C:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  role       = aws_iam_role.ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = "v1.63.1-eksbuild.1"
  service_account_role_arn    = aws_iam_role.ebs_csi_driver.arn
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_iam_role_policy_attachment.ebs_csi_driver
  ]
}
