terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["591542846629"] #amazon
  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-*"]
  }
}

resource "aws_iam_role" "role-elb" {
  name = "role-elb-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "tf-ellb" {
  name = "aws-elasticbeanstalk-ec2-role" # use the same name as the default instance profile

  role = aws_iam_role.role-elb.name
}

resource "aws_elastic_beanstalk_application" "eb_app" {
  name = "demo-app"
}

resource "aws_elastic_beanstalk_environment" "eb_env" {
  application = aws_elastic_beanstalk_application.eb_app.name
  name        = "demo"
  solution_stack_name = "64bit Amazon Linux 2023 v4.2.4 running Corretto 17"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.tf-ellb.name
  }
}

output "eb_url" {
  value = aws_elastic_beanstalk_environment.eb_env.endpoint_url
}
