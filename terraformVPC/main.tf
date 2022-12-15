terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

module "cloudLearning9-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "cloudLearning9-vpc"
  cidr = var.VPC_CIDR_BLOCK[0]

  azs            = var.AZ_MAP[var.AWS_REGION]
  public_subnets = var.VPC_PUBLIC_SUBNETS

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    CloudLearningGroup = var.CLOUD_LEARNING_GROUP
  }
}

