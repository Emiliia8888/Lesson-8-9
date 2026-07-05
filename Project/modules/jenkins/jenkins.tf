resource "kubernetes_namespace_v1" "jenkins" {
  metadata {
    name = "jenkins"
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
        container {
          name  = "jenkins"
          image = "jenkins/jenkins:lts"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
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
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}
