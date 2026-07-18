resource "helm_release" "jenkins" {

  name = "jenkins"

  repository = "https://charts.jenkins.io"

  chart = "jenkins"

  version = var.chart_version


  namespace = var.namespace

  create_namespace = false


  timeout = 900


  values = [
    file("${path.module}/values.yaml")
  ]


  depends_on = [
    kubernetes_service_account.jenkins
  ]
}
