terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "XBrain-K8s-Lab"
      Environment = "lab"
      ManagedBy   = "Terraform"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = pathexpand("~/.kube/config")
  }
}

locals {
  environment_name = "xbrain-k8s-lab"
  instance_name    = "${local.environment_name}-ec2"
  vpc_cidr         = var.vpc_cidr
}
