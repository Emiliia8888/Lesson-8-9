resource "kubernetes_namespace_v1" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins-test"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "5.9.36"
  namespace  = kubernetes_namespace_v1.jenkins.metadata[0].name

  values = [
    file("${path.module}/values.yaml")
  ]
}
