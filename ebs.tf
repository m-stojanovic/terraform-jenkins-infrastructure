resource "aws_dlm_lifecycle_policy" "jenkins_ebs" {
  description        = "jenkins ebs"
  execution_role_arn = aws_iam_role.aws_ebs_lifecycle.arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "one week of daily snapshots"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["23:45"]
      }

      retain_rule {
        count = 7
      }

      tags_to_add = {
        SnapshotCreator = "DLM"
      }

      copy_tags = true
    }

    target_tags = {
      Name = "${var.environment}-${var.eks_cluster_name}-vol"
    }
  }
  tags = local.tags
}
