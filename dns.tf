resource "aws_route53_record" "primary_jenkins" {
  zone_id = var.devdevops_com_zone_id
  name    = var.primary_jenkins_hostname
  records = [var.jenkins.default.hostname]
  type    = "CNAME"
  ttl     = "60"
}
