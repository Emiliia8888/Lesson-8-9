resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

# Створюємо сервіс LoadBalancer, щоб отримати посилання на адмінку
resource "kubernetes_service_v1" "argocd_server_lb" {
  metadata {
    name      = "argocd-server-external"
    namespace = kubernetes_namespace_v1.argocd.metadata[0].name
  }
  spec {
    selector = {
      "app.kubernetes.io/name" = "argocd-server"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}
