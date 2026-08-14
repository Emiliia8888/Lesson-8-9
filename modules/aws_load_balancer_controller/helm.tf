resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "3.4.2"
  namespace  = "kube-system"

  set = [
    {
      name  = "clusterName"
      value = "dev-eks-cluster"
    },
    {
      name  = "vpcId"
      value = "vpc-0a193c45e151d961d"
    },
    {
      name  = "serviceAccount.create"
      value = "false"
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    }
  ]

  depends_on = [
    kubernetes_service_account_v1.aws_load_balancer_controller
  ]
}
