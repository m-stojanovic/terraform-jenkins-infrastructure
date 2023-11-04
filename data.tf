data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["devops-ci"]
  }
}

data "aws_subnet" "vpc-public-eu-west-1a" {
  filter {
    name   = "tag:Name"
    values = ["ci vpc-public-eu-west-1a"]
  }
}

data "aws_subnet" "vpc-public-eu-west-1b" {
  filter {
    name   = "tag:Name"
    values = ["ci vpc-public-eu-west-1b"]
  }
}

data "aws_subnet" "vpc-private-eu-west-1a" {
  filter {
    name   = "tag:Name"
    values = ["ci vpc-private-eu-west-1a"]
  }
}

data "aws_subnet" "vpc-private-eu-west-1b" {
  filter {
    name   = "tag:Name"
    values = ["ci vpc-private-eu-west-1b"]
  }
}

variable "jenkins_slave_security_group_id" {
  default = "sg-xxxx"
}

data "aws_route_table" "vpc-route-table-eu-west-1a" {
  subnet_id = data.aws_subnet.vpc-private-eu-west-1a.id
}

data "aws_route_table" "vpc-route-table-eu-west-1b" {
  subnet_id = data.aws_subnet.vpc-private-eu-west-1b.id
}

data "aws_acm_certificate" "jenkins" {
  domain   = "*.devdevops.com"
  statuses = ["ISSUED"]
  types    = ["AMAZON_ISSUED"]
}

data "aws_region" "current" {}
