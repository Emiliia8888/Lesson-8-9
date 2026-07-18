resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = module.aws_eks.cluster_name

  addon_name = "aws-ebs-csi-driver"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}
