data "aws_eks_cluster" "cluster" { name = var.eks_cluster_name }
data "aws_eks_cluster_auth" "cluster" { name = var.eks_cluster_name }

data "aws_ebs_volume" "jenkins" {
  most_recent = true

  filter {
    name   = "tag:Terraform"
    values = ["true"]
  }

  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.environment}-${var.eks_cluster_name}-vol"]
  }

}
data "aws_region" "current" {}