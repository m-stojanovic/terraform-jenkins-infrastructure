locals {
  az_bind = {
    default  = "eu-west-1a"
  }
  labels = {
    "app.kubernetes.io/managed-by" = "Terraform"
    jenkins-jenkins-config         = "true"
  }
}

resource "kubernetes_config_map" "jcasc" {
  metadata {
    name      = "jenkins-jenkins-jcasc-cipoc-tf"
    namespace = "default"
    labels    = local.labels
  }

  data = {
    "welcome_message.yaml" = "${file("jcasc/welcome_message.yaml")}"
    "jenkins_clouds.yaml" = templatefile("jcasc/jenkins_clouds.yaml", {
      jenkins_host = var.jenkins.default.hostname
      jenkins_env  = "prod"
      second_env   = "dev"

      ami_jenkins_slave_java8  = data.aws_ami.jenkins_slave_java8.id
      ami_jenkins_slave_java11 = data.aws_ami.jenkins_slave_java11.id
      ami_jenkins_slave_sbt    = data.aws_ami.jenkins_slave_sbt.id
    })
    "jenkins_auth.yaml"             = "${file("jcasc/jenkins_auth.yaml")}"
    "jenkins_misc.yaml"             = "${file("jcasc/jenkins_misc.yaml")}"
    "security.yaml"                 = "${file("jcasc/security.yaml")}"
    "tool.yaml"                     = "${file("jcasc/tool.yaml")}"
    "unclassified_global_conf.yaml" = "${file("jcasc/unclassified_global_conf.yaml")}"
    "unclassified.yaml" = templatefile("jcasc/unclassified.yaml", {
      jenkins_host = var.jenkins.default.hostname
    })
  }
}
