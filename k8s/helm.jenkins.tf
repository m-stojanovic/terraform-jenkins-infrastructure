module "jm" {
  source  = "terraform-module/release/helm"
  version = "2.8.0"

  namespace  = "default"
  repository = "https://charts.jenkins.io"

  app = {
    name          = "jenkins"
    version       = "4.3.0"
    chart         = "jenkins"
    force_update  = false
    wait          = false
    recreate_pods = true
    deploy        = 1
  }
  values = [templatefile("helm/jenkins.yaml", {
    volume        = kubernetes_persistent_volume_claim.jenkins_ebs.0.metadata.0.name
    http_port     = var.jenkins.default.port.http
    agent_port    = var.jenkins.default.port.agent
    hostname      = var.jenkins.default.hostname
    image_name    = "jenkins/jenkins"
    image_tag     = "2.375.3-lts-jdk11"
  })]

}