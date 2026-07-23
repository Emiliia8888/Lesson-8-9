data "aws_iam_policy_document" "aws_load_balancer_controller_assume_role" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {

      type = "Federated"

      identifiers = [
        var.oidc_provider_arn
      ]
    }

    condition {

      test = "StringEquals"

      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account_name}"
      ]
    }
  }
}


resource "aws_iam_role" "aws_load_balancer_controller" {

  name = "${var.cluster_name}-aws-load-balancer-controller-role"

  assume_role_policy = data.aws_iam_policy_document.aws_load_balancer_controller_assume_role.json
}


resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {

  role = aws_iam_role.aws_load_balancer_controller.name

  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}


resource "aws_iam_policy" "aws_load_balancer_controller" {

  name = "${var.cluster_name}-AWSLoadBalancerControllerIAMPolicy"

  policy = file("${path.module}/iam_policy.json")
}
