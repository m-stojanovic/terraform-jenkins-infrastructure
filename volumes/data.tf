data "aws_ebs_snapshot_ids" "jenkins" {
  owners = ["self"]

  filter {
    name   = "tag:Name"
    values = ["jenkins-vol-1"]
  }

}