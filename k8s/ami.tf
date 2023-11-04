data "aws_ami" "ec2-linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

variable "aws_ami" {
  default = "ami-e4515e0e"
}

data "aws_ami" "jenkins_slave_java8" {
  name_regex       = "^jenkins-slave-java8-\\d{12}"
  most_recent      = true
  owners           = ["self"]
}

data "aws_ami" "jenkins_slave_java11" {
  name_regex       = "^jenkins-slave-java11-\\d{12}"
  most_recent      = true
  owners           = ["self"]
}

data "aws_ami" "jenkins_slave_sbt" {
  name_regex       = "^jenkins-slave-sbt-\\d{12}"
  most_recent      = true
  owners           = ["self"]
}