resource "kubernetes_namespace_v1" "jenkins" {

  metadata {

    name = "jenkins"

  }

}


resource "kubernetes_service_account_v1" "jenkins" {

  metadata {

    name = "jenkins"

    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name

  }

}


resource "kubernetes_role_v1" "jenkins" {

  metadata {

    name = "jenkins"

    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name

  }


  rule {

    api_groups = [""]

    resources = [
      "pods",
      "pods/exec",
      "pods/log"
    ]

    verbs = [
      "create",
      "delete",
      "get",
      "list",
      "watch"
    ]

  }

}


resource "kubernetes_role_binding_v1" "jenkins" {

  metadata {

    name = "jenkins"

    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name

  }


  role_ref {

    api_group = "rbac.authorization.k8s.io"

    kind = "Role"

    name = kubernetes_role_v1.jenkins.metadata[0].name

  }


  subject {

    kind = "ServiceAccount"

    name = kubernetes_service_account_v1.jenkins.metadata[0].name

    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name

  }

}



resource "kubernetes_deployment_v1" "jenkins" {

  metadata {

    name = "jenkins"

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

          name = "jenkins"

          image = "jenkins/jenkins:lts"


          port {

            container_port = 8080

          }


          volume_mount {

            name = "jenkins-home"

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

}




resource "kubernetes_service_v1" "jenkins" {

  metadata {

    name = "jenkins"

    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name

  }


  spec {

    selector = {

      app = "jenkins"

    }


    port {

      port = 80

      target_port = 8080

    }


    type = "LoadBalancer"

  }

}


