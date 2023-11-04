
locals {
  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"
          labels = {
            eks-target = "fargate"
          }
        },
      ]
      tags = local.tags
    }
  }
  aws_auth_roles = [
    {
      rolearn  = aws_iam_role.eks_admin_role.arn
      username = "admin:{{SessionName}}"
      groups   = ["system:masters"]
    },
  ]
  aws_auth_devops_users = [for devops in data.aws_iam_group.devops.users :
    {
      userarn  = devops.arn
      username = devops.user_name
      groups   = ["system:masters"]
    }
  ]
  aws_auth_users = concat([
    {
      userarn  = var.jenkins_user
      username = "jenkins:{{SessionName}}"
      groups   = ["system:masters"]
    },
  ],
  local.aws_auth_devops_users)

  self_managed_node_groups = {
    jenkins = {
      name                  = "jenkins"
      ami_id                = "ami-0209251d863e91768"
      instance_type         = "m5.xlarge"
      desired_size          = var.jenkins_ec2_count
      max_size              = var.jenkins_ec2_count
      min_size              = var.jenkins_ec2_count
      key_name              = var.nodes_key_pair_name
      subnet_ids            = [data.aws_subnet.vpc-private-eu-west-1a.id]
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 75
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            delete_on_termination = true
          }
        }
      }
      target_group_arns     = concat(module.nlb.target_group_arns, module.alb_webhook.target_group_arns)
    },
  }
  kms_key_administrators = [for devops in data.aws_iam_group.devops.users :
    devops.arn
  ]
}

module "eks" {
  source                                  = "terraform-aws-modules/eks/aws"
  version                                 = "~> 19.10.0"
  cluster_version                         = "1.24"
  cluster_name                            = var.eks_cluster_name
  vpc_id                                  = data.aws_vpc.vpc.id
  enable_irsa                             = true
  subnet_ids                              = [data.aws_subnet.vpc-private-eu-west-1a.id, data.aws_subnet.vpc-private-eu-west-1b.id]
  self_managed_node_group_defaults        = {
    vpc_security_group_ids = concat(var.nodes_security_group_ids, tolist([aws_security_group.eks_node.id]))
  }
  tags                                    = local.tags
  aws_auth_roles                          = local.aws_auth_roles
  aws_auth_users                          = local.aws_auth_users
  self_managed_node_groups                = local.self_managed_node_groups
  fargate_profiles                        = local.fargate_profiles
  prefix_separator                        = ""
  create_aws_auth_configmap               = true
  manage_aws_auth_configmap               = true
  kms_key_administrators                  = local.kms_key_administrators
  cluster_security_group_additional_rules = {
    ingress_vpc_https = {
      description = "Remote host to control plane"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
