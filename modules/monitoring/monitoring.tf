resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "88.2.0"
  namespace  = "monitoring"

  values = [
    file("${path.module}/values.yaml")
  ]

  timeout = 300
  wait    = true
}
