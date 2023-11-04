module "ingress_nginx" {
  source  = "terraform-module/release/helm"
  version = "2.8.0"

  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/ingress-nginx"

  app = {
    name          = "ingress-nginx"
    version       = "4.0.6"
    chart         = "ingress-nginx"
    force_update  = false
    wait          = false
    recreate_pods = false
    deploy        = 1
  }
  values = [templatefile("helm/ingress.yaml", {
  })]

}