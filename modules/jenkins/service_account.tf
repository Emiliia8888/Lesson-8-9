resource "kubernetes_service_account" "jenkins" {

  metadata {

    name = "jenkins"

    namespace = var.namespace


    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.jenkins.arn
    }


    labels = {
      app = "jenkins"
    }
  }
}
