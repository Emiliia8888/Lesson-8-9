data "aws_iam_policy_document" "jenkins_assume_role" {

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
        "system:serviceaccount:${var.namespace}:jenkins"
      ]
    }
  }
}



resource "aws_iam_role" "jenkins" {

  name = "${var.cluster_name}-jenkins-role"


  assume_role_policy = data.aws_iam_policy_document.jenkins_assume_role.json
}



data "aws_iam_policy_document" "jenkins_policy" {

  statement {

    effect = "Allow"


    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]


    resources = [
      "*"
    ]
  }
}



resource "aws_iam_role_policy" "jenkins" {

  name = "${var.cluster_name}-jenkins-policy"


  role = aws_iam_role.jenkins.id


  policy = data.aws_iam_policy_document.jenkins_policy.json
}
