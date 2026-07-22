output "jenkins_namespace" {
  description = "Jenkins namespace"
  value       = var.namespace
}

output "jenkins_release" {
  description = "Jenkins Helm release"
  value       = helm_release.jenkins.name
}
