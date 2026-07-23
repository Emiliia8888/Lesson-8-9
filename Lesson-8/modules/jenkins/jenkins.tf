resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = var.chart_version

  namespace        = var.namespace
  create_namespace = true

  timeout = 900

  values = [
    file("${path.module}/values.yaml")
  ]
}