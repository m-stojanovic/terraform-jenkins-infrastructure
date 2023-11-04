# Copied from Old Jenkins module
# TODO: review and refactor

# Attach Policy to the EC2 instance profile to allow Jenkins master to launch and control slave EC2 instances
resource "aws_iam_role_policy_attachment" "slaves_backport" {
  role       = module.eks.self_managed_node_groups.jenkins.iam_role_name
  policy_arn = aws_iam_policy.slaves_backport.arn
}

# Policy for the EB EC2 instance profile to allow launching Jenkins slaves
resource "aws_iam_policy" "slaves_backport" {
  name        = "${var.environment}-${var.eks_cluster_name}-from-old-jenkins"
  path        = "/"
  description = "Policy for EC2 instance profile to allow launching Jenkins slaves"
  policy      = data.aws_iam_policy_document.slaves_backport.json
}

# Policy document with permissions to launch new EC2 instances
# https://wiki.jenkins.io/display/JENKINS/Amazon+EC2+Plugin
data "aws_iam_policy_document" "slaves_backport" {
  statement {
    sid = "AllowLaunchingEC2Instances"

    actions = [
      "ec2:DescribeSpotInstanceRequests",
      "ec2:CancelSpotInstanceRequests",
      "ec2:GetConsoleOutput",
      "ec2:RequestSpotInstances",
      "ec2:RunInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DescribeInstances",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeRegions",
      "ec2:DescribeImages",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "iam:PassRole",
    ]

    resources = ["*"]
    effect    = "Allow"
  }
}
