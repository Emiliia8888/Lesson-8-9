resource "kubernetes_service_account" "aws_load_balancer_controller" {

  metadata {

    name = var.service_account_name

    namespace = var.namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.aws_load_balancer_controller.arn
    }
  }
}
