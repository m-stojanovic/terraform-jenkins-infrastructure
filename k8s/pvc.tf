locals { ebs_size = "128Gi" }

resource "kubernetes_persistent_volume_claim" "jenkins_ebs" {
  count = var.jenkins_pvc_count
  metadata {
    name      = "jenkins-ebs"
    namespace = "default"
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "ebs-sc"
    resources {
      requests = { storage = local.ebs_size }
    }
    volume_name = kubernetes_persistent_volume.jenkins_ebs.0.id
  }
}

resource "kubernetes_persistent_volume" "jenkins_ebs" {
  count = var.jenkins_pvc_count
  metadata { name = "jenkins-ebs" }
  spec {
    capacity     = { storage = local.ebs_size }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = "ebs-sc"
    persistent_volume_source {
      csi {
        driver        = "ebs.csi.aws.com"
        fs_type       = "ext4"
        volume_handle = data.aws_ebs_volume.jenkins.id
      }
    }
  }
}
