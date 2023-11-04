module "splunk" {
  source  = "terraform-module/release/helm"
  version = "2.8.0"

  namespace  = "kube-system"
  repository = "https://splunk.github.io/splunk-connect-for-kubernetes"

  app = {
    name          = "splunk"
    version       = "1.5.3"
    chart         = "splunk-connect-for-kubernetes"
    force_update  = false
    wait          = false
    recreate_pods = false
    deploy        = 1
  }
  values = [file("helm/splunk.yaml")]

}