
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}
variable "aws_owner_id" {}
variable "aws_region" {
  default = "eu-west-1"
}

variable "nodes_key_pair_name" {
  description = "The EC2 key pair name that should be used for the instance. Instance cannot be connected using SSH if key pair name is not given."
  default     = "devops-ci"
}

variable "nodes_security_group_ids" {
  description = "List of security group IDs protecting container instances"
  type        = list(string)
  default     = ["sg-xxxx"]
}

variable "ci_vpc" {
  default = "vpc-xxxx"
}

variable "rancher_cidr" {
  default = ["xxxx/24"]
}

variable "office_public_cidr" {
  default = ["xxxx/22", "xxxx/32", "xxxx/32"]
}

variable "office_private_cidr" {
  default = ["xxxx/24", "xxxx/24"]
}

variable "office_private_cidr_1" {
  default = ["xxxx/24"]
}

variable "office_private_cidr_2" {
  default = ["xxxx/24"]
}

variable "splunk_private_cidr" {
  default = ["xxxx/23"]
}

variable "gateway_external_cidr" {
  default = ["xxxx/32"]
}

variable "gateway_internal_cidr" {
  default = ["xxxx/32"]
}

variable "devops_vpn_pub_cidr" {
  default = ["xxxx/32"]
}

variable "devops_vpn_prv_cidr" {
  default = ["xxxx/32"]
}

variable "openvpn_server_prv_cidr" {
  default = ["xxxx/32"]
}

variable "teamcity_agents_pub" {
  default = "xxxx/32,xxxx/32"
}

variable "alertlogic_green_ip" {
  default = "xxxx/32,xxxx/32"
}

variable "festatic_sg_rule" {
  default = "0.0.0.0/0"
}

variable "jenkins_agents_pub" {
  default = "xxxx/32,xxxx/32"
}

variable "newrelic_common_ip" {
  default = "xxxx/32"
}

variable "redshift_related_ips" {
  default = "xxxx/24,xxxx/24"
}

variable "green_ecs_cidr" {
  default = "xxxx/21"
}

variable "cloudflare_ips" {
  default = "xxxx/24"
}

variable "bi_vpc_cidr" {
  default = "xxxx/24"
}

data "aws_vpc" "dev_and_int" {
  id = "vpc-xxxx"
}

data "aws_subnet" "dev_and_int_subnet" {
  id = "subnet-xxxx"
}

variable "environment" {
  default = "ci"
}

variable "environment_name" {
  default = "ci"
}

variable "devdevops_com_zone_id" {
  default = "xxxx"
}

locals {
  aws_ecs_autoscaling_role = "arn:aws:iam::xxxx:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
}

variable "root_block_device" {
  type = map(string)
  default = {
    volume_size = "16"
    volume_type = "gp2"
  }
}

variable "jenkins_user" {
  default = "arn:aws:iam::xxxx:user/jenkins_user"
}

variable "jenkins" {
  default = {
    old = {
      hostname = "internal-awseb-e-p-AWSEBLoa-xxxx-xxxx.eu-west-1.elb.amazonaws.com"
    },
    default = {
      hostname = "devops-jenkins-prod.devdevops.com"
      port = {
        http  = 32080
        https = 32443
        agent = 30151
      }
    },
    webhook = {
      hostname = "devops-ci.devdevops.com"
      port = {
        http  = 32080
        https = 32443
      }
      paths = ["/multibranch-webhook-trigger","/generic-webhook-trigger"]
    },
  }
}

variable "primary_jenkins_hostname" { default = "devops-jenkins.devdevops.com" }
# must be either blue or green
variable "jenkins_primary_env" { default = "blue" }
# must be either 1 or 0
variable "jenkins_ec2_count" { default = 1 }
variable "jenkins_pvc_count" { default = 1 }
variable "jenkins_helm_deploy" { default = 1 }

variable "eks_cluster_name" {
  default     = "jenkins-prod"
  description = "Name of a EKS cluster where master instance(s) is(are) registered into"
}

variable "name_prefix" {
  default     = "jenkins"
  description = "Prfix name for all related resources"
}
variable "tags" {
  default = {}
}

locals {
  tags = merge(
    {
      Terraform   = "true"
      Environment = var.environment
    },
    var.tags,
  )
}