module "aws_ebs_csi_driver" {
  source  = "terraform-module/release/helm"
  version = "2.8.0"

  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"

  app = {
    name          = "aws-ebs-csi-driver"
    version       = "2.10.0"
    chart         = "aws-ebs-csi-driver"
    force_update  = true
    wait          = false
    recreate_pods = false
    deploy        = 1
  }
  values = [templatefile("helm/aws-ebs-csi-driver.yaml", {
    sa_role_arn = data.aws_iam_role.aws_ebs_csi_driver.arn
    aws_region  = data.aws_region.current.name
  })]

}

data "aws_iam_role" "aws_ebs_csi_driver" {
  name = "${var.eks_cluster_name}-awsebscsi-role"
}