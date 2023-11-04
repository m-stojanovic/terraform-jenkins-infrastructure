resource "aws_security_group" "eks_node" {
  name        = "${var.environment}-${var.eks_cluster_name}-sg"
  description = "EKS Node SG"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "Access to the Node instance(s) via SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = var.gateway_internal_cidr
  }

  ingress {
    description = "Allow access to nodes from whole vpc"
    from_port   = 1025
    to_port     = 65535
    protocol    = "TCP"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }

  ingress {
    description = "Allow access via nlb"
    from_port   = 80
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow access to DNS"
    from_port   = 53
    to_port     = 53
    protocol    = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow access to nodes NodePort range"
    from_port   = 30000
    to_port     = 32767
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "${var.environment}-${var.eks_cluster_name}-sg" },
    local.tags
  )

}

resource "aws_security_group_rule" "eks_node_to_cluster_access" {
  description              = "Allow access to cluster sg from node sg"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.eks_node.id

  security_group_id = module.eks.cluster_primary_security_group_id
}

resource "aws_security_group" "alb" {
  name        = "${var.environment}-${var.eks_cluster_name}-alb-sg"
  description = "Load Balancer SG"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "Access to Load Balancer(s) HTTP Port"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Access to Load Balancer(s) HTTPS Port"
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

  tags = merge(
    { Name = "${var.environment}-jenkins-alb-sg" },
    local.tags
  )

}
