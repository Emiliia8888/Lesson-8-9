data "aws_caller_identity" "current" {}

resource "kubernetes_namespace_v1" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

data "aws_iam_policy_document" "jenkins_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(var.oidc_issuer, "https://", "")}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_issuer, "https://", "")}:sub"
      values = [
        "system:serviceaccount:jenkins:jenkins"
      ]
    }
  }
}

data "aws_iam_policy_document" "jenkins_policy" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:UploadLayerPart",
      "ecr:PutImage",
      "ecr:ListImages",
      "ecr:InitiateLayerUpload",
      "ecr:GetRepositoryPolicy",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "ecr:DescribeRepositories",
      "ecr:CompleteLayerUpload",
      "ecr:BatchCheckLayerAvailability",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "jenkins" {
  name               = "dev-eks-cluster-jenkins-role"
  assume_role_policy = data.aws_iam_policy_document.jenkins_assume_role.json
}

resource "aws_iam_role_policy" "jenkins" {
  name   = "dev-eks-cluster-jenkins-policy"
  role   = aws_iam_role.jenkins.id
  policy = data.aws_iam_policy_document.jenkins_policy.json
}

resource "kubernetes_service_account_v1" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.jenkins.arn
    }
  }

  automount_service_account_token = true
}

resource "kubernetes_role_v1" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name
  }

  rule {
    api_groups = [""]
    resources = [
      "pods",
      "pods/exec",
      "pods/log",
    ]

    verbs = [
      "create",
      "delete",
      "get",
      "list",
      "watch",
    ]
  }
}

resource "kubernetes_role_binding_v1" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.jenkins.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.jenkins.metadata[0].name
    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name
  }
}

resource "kubernetes_deployment_v1" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "jenkins"
      }
    }

    template {
      metadata {
        labels = {
          app = "jenkins"
        }
      }

      spec {
        service_account_name = kubernetes_service_account_v1.jenkins.metadata[0].name

        container {
          name  = "jenkins"
          image = "jenkins/jenkins:lts"

          port {
            container_port = 8080
          }

          volume_mount {
            name       = "jenkins-home"
            mount_path = "/var/jenkins_home"
          }
        }

        volume {
          name = "jenkins-home"

          empty_dir {}
        }
      }
    }
  }

  wait_for_rollout = true
}

resource "kubernetes_service_v1" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name
  }

  spec {
    selector = {
      app = "jenkins"
    }

    type = "LoadBalancer"

    load_balancer_class = "service.k8s.aws/nlb"

    port {
      port        = 80
      target_port = "8080"
    }
  }

  wait_for_load_balancer = true
}
