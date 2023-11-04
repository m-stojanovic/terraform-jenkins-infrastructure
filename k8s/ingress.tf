resource "kubernetes_ingress_v1" "webhook" {

  metadata {
    name      = "webhook-jenkins"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class"                         = "nginx"
      "nginx.ingress.kubernetes.io/force-ssl-redirect"      = "true"
      "nginx.ingress.kubernetes.io/preserve-trailing-slash" = "true"
    }
  }

  spec {
    rule {
      host = var.jenkins.webhook.hostname
      http {
        dynamic "path" {
          for_each = var.jenkins.webhook.paths
          content {
            path = path.value
            backend {
              service {
                name = "jenkins"
                port {
                  number = 8080
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "primary_jenkins" {

  metadata {
    name = "primary-jenkins"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/preserve-trailing-slash" = "true"
    }
  }

  spec {

    rule {
      host = var.primary_jenkins_hostname
      http {
        path {
          backend {
            service {
              name = "jenkins"
              port {
                number = 8080
              }
            }
          }
        }

      }
    }

  }
}
