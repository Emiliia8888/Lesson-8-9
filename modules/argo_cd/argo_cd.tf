resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.7.16"

  namespace = kubernetes_namespace_v1.argocd.metadata[0].name

  values = [
    file("${path.module}/../values/argocd-values.yaml")
  ]

  depends_on = [
    kubernetes_namespace_v1.argocd
  ]
}

resource "kubernetes_service_v1" "argocd_server_lb" {
  metadata {
    name      = "argocd-server-external"
    namespace = "argocd"
  }

  spec {
    selector = {
      "app.kubernetes.io/name" = "argocd-server"
    }

    type = "LoadBalancer"

    load_balancer_class = "service.k8s.aws/nlb"

    port {
      port        = 80
      target_port = 8080
      protocol    = "TCP"
    }
  }

  wait_for_load_balancer = true

  depends_on = [
    helm_release.argocd
  ]
}
