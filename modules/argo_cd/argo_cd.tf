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


#resource "helm_release" "argocd_apps" {
#  name       = "argocd-apps"
#  chart      = "${path.module}/charts/argocd-apps"
#  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
#  depends_on = [helm_release.argo_cd]
#}