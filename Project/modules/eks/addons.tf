resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = aws_eks_cluster.this[0].name

  addon_name = "aws-ebs-csi-driver"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}