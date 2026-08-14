resource "aws_kms_key" "eks" {
  description         = "KMS key for EKS secrets encryption"
  enable_key_rotation = true

  tags = {
    Name = "${var.environment}-eks-kms"
  }
}

resource "aws_kms_alias" "eks" {
  name          = "alias/eks/dev-eks-cluster"
  target_key_id = aws_kms_key.eks.key_id
}
