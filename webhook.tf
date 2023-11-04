locals {
  name_prefix_webhook = "${var.environment}-${var.name_prefix}-webhook"
}

module "alb_webhook" {
  source                           = "terraform-aws-modules/alb/aws"
  version                          = "~> 8.3"
  name                             = "${local.name_prefix_webhook}-alb"
  load_balancer_type               = "application"
  vpc_id                           = data.aws_vpc.vpc.id
  subnets                          = [data.aws_subnet.vpc-public-eu-west-1a.id, data.aws_subnet.vpc-public-eu-west-1b.id]
  security_groups                  = [aws_security_group.alb_webhook.id]
  internal                         = false
  enable_cross_zone_load_balancing = true

  target_groups = [
    {
      name             = "${local.name_prefix_webhook}-tls"
      backend_protocol = "HTTPS"
      backend_port     = var.jenkins.webhook.port.https
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/healthz"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 10
        protocol            = "HTTPS"
        matcher             = "200"
      }
    },
  ]

  https_listeners = [
    {
      name            = "${local.name_prefix_webhook}-https"
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = data.aws_acm_certificate.jenkins.arn
      action_type     = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Access denied"
        status_code  = "401"
      }
    }
  ]

  https_listener_rules = [
    {
      https_listener_index = 0
      actions = [
        {
          type               = "forward"
          target_group_index = 0
        }
      ]
      conditions = [{
        host_headers = [var.jenkins.webhook.hostname]
      }]
    },
  ]
  tags                 = local.tags
  lb_tags              = local.tags
  target_group_tags    = local.tags
  https_listeners_tags = { Name = "${local.name_prefix_webhook}-https" }
}

resource "aws_route53_record" "jenkins_webhook" {
  zone_id = var.devdevops_com_zone_id
  name    = var.jenkins.webhook.hostname
  type    = "A"

  alias {
    name                   = module.alb_webhook.lb_dns_name
    zone_id                = module.alb_webhook.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_security_group" "alb_webhook" {
  name        = "${local.name_prefix_webhook}-sg"
  description = "Jenkins Webhook LB SG"
  vpc_id      = data.aws_vpc.vpc.id
  tags        = local.tags

  ingress {
    description = "Public access to the webhook LB"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
