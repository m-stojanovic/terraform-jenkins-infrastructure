resource "aws_ebs_volume" "jenkins" {

  availability_zone = "eu-west-1a"
  type              = "gp3"
  snapshot_id       = data.aws_ebs_snapshot_ids.jenkins.ids[0]

  tags = merge(
    { Name = "${var.environment}-${var.eks_cluster_name}-vol" },
    local.tags,
  )
  lifecycle {
    ignore_changes = [ snapshot_id ]
  }

}

resource "aws_ebs_snapshot" "jenkins-one" {
  volume_id = aws_ebs_volume.jenkins.id

  tags = merge(
    { Name = "${var.environment}-${var.eks_cluster_name}-snap" },
    local.tags,
  )
}

resource "aws_ebs_volume" "jenkins-one" {

  availability_zone = "eu-west-1a"
  type              = "gp3"
  snapshot_id       = aws_ebs_snapshot.jenkins-one.id

  tags = merge(
    { Name = "${var.environment}-${var.eks_cluster_name}-vol" },
    local.tags,
  )

}
