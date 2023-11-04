variable "environment" {
  default = "ci"
}

variable "eks_cluster_name" {
  default     = "jenkins-prod"
  description = "Name of a EKS cluster where master instance(s) is(are) registered into"
}

variable "tags" {
  default = {}
}

locals {
  tags = merge(
    {
      Terraform   = "true"
      Environment = var.environment
    },
    var.tags,
  )
}