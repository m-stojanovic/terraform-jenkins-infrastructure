resource "aws_iam_role" "aws_ebs_lifecycle" {
  name = "${var.eks_cluster_name}-awsebslifecycle-role"
  tags = local.tags
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "dlm.amazonaws.com"
          }
          Sid = ""
        },
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy" "aws_ebs_lifecycle" {
  name = "${var.eks_cluster_name}-awsebslifecycle-policy"
  role = aws_iam_role.aws_ebs_lifecycle.id

  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "ec2:CreateSnapshot",
            "ec2:CreateSnapshots",
            "ec2:DeleteSnapshot",
            "ec2:DescribeInstances",
            "ec2:DescribeVolumes",
            "ec2:DescribeSnapshots",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "ec2:CreateTags",
          ]
          Effect   = "Allow"
          Resource = "arn:aws:ec2:*::snapshot/*"
        },
      ]
      Version = "2012-10-17"
    }
  )

}
