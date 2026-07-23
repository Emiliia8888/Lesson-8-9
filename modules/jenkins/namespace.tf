resource "kubernetes_namespace_v1" "jenkins" {
  metadata {
    name = var.namespace
  }
}
