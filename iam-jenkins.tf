locals {
  base_name = "${var.environment}-${var.eks_cluster_name}-eks-admin"
}

data "aws_iam_policy_document" "jenkins" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    resources = ["*"]

    effect = "Allow"
  }

}

data "aws_caller_identity" "current" {}

data "aws_iam_group" "devops" {
  group_name = "DevOps"
}

resource "aws_iam_role_policy" "jenkins" {
  name   = "${var.environment}-${var.eks_cluster_name}"
  role   = module.eks.self_managed_node_groups.jenkins.iam_role_name
  policy = data.aws_iam_policy_document.jenkins.json
}

resource "aws_iam_role" "eks_admin_role" {

  description          = "Kubernetes administrator role (used with AWS IAM Authenticator)."
  max_session_duration = "43200"
  path                 = "/"
  name                 = local.base_name
  tags = merge(
    { Name = local.base_name },
    local.tags
  )
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole"]
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      },
    ]
  })
}
