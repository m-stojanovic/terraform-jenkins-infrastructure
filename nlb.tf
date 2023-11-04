locals {
  name_prefix = "${var.environment}-${var.eks_cluster_name}"
  create_lb   = true
}

module "nlb" {
  create_lb                        = local.create_lb
  source                           = "terraform-aws-modules/alb/aws"
  version                          = "~> 8.3"
  name                             = "${local.name_prefix}-${var.environment}-nlb"
  load_balancer_type               = "network"
  vpc_id                           = data.aws_vpc.vpc.id
  subnets                          = [data.aws_subnet.vpc-private-eu-west-1a.id, data.aws_subnet.vpc-private-eu-west-1b.id]
  internal                         = true
  enable_cross_zone_load_balancing = true

  target_groups = [
    {
      name             = "${local.name_prefix}-http"
      backend_protocol = "TCP"
      backend_port     = var.jenkins.default.port.http
      target_type      = "instance"
      health_check = {
        enabled  = true
        port     = "${var.jenkins.default.port.http}"
        protocol = "HTTP"
        path     = "/healthz"
      }
    },
    {
      name             = "${local.name_prefix}-agent"
      backend_protocol = "TCP"
      backend_port     = var.jenkins.default.port.agent
      target_type      = "instance"
      health_check = {
        enabled  = true
        port     = "${var.jenkins.default.port.http}"
        protocol = "HTTP"
        path     = "/healthz"
      }
    },
    {
      name             = "${local.name_prefix}-https"
      backend_protocol = "TLS"
      backend_port     = var.jenkins.default.port.https
      target_type      = "instance"
      health_check = {
        enabled  = true
        port     = "${var.jenkins.default.port.http}"
        protocol = "HTTP"
        path     = "/healthz"
      }
    },
  ]

  https_listeners = [
    {
      name               = "${local.name_prefix}-https"
      port               = 443
      protocol           = "TLS"
      certificate_arn    = data.aws_acm_certificate.jenkins.arn
      target_group_index = 2
    }
  ]

  http_tcp_listeners = [
    {
      name               = "${local.name_prefix}-http"
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    },
    {
      name               = "${local.name_prefix}-agent"
      port               = 50000
      protocol           = "TCP"
      target_group_index = 1
    },
  ]

  tags                    = local.tags
  lb_tags                 = local.tags
  target_group_tags       = local.tags
  http_tcp_listeners_tags = { Name = "${local.name_prefix}-tcp" }
  https_listeners_tags    = { Name = "${local.name_prefix}-https" }
}

resource "aws_route53_record" "jenkins" {
  count   = var.jenkins_ec2_count
  zone_id = var.devdevops_com_zone_id
  name    = var.jenkins.default.hostname
  type    = "A"

  alias {
    name                   = module.nlb.lb_dns_name
    zone_id                = module.nlb.lb_zone_id
    evaluate_target_health = true
  }
}
