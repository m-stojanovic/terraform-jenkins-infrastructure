# see also https://docs.aws.amazon.com/eks/latest/userguide/cni-iam-role.html

locals {
  oidc_parts              = split("/", module.eks.oidc_provider_arn)
  oidc_condition_string   = "${local.oidc_parts[1]}/${local.oidc_parts[2]}/${local.oidc_parts[3]}"
}

resource "aws_iam_role" "aws_eks_vpc_cni" {
  name               = "${var.eks_cluster_name}-awseksvpccni-role"
  tags               = local.tags
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${module.eks.oidc_provider_arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${local.oidc_condition_string}:aud": "sts.amazonaws.com",
          "${local.oidc_condition_string}:sub": "system:serviceaccount:kube-system:aws-node"
        }
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_iam_role_policy_attachment" "aws_eks_vpc_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.aws_eks_vpc_cni.name
}
