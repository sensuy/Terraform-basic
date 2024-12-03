terraform {
  required_version = "1.9.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.77.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
  }

    backend "s3" {
        bucket = "myfcbucket"
        key    = "terraform.tfstate"
        region = "us-east-2"
    }
}

provider "aws" {
  region = "us-east-2"
}

module "new-vpc" {
    source = "./modules/vpc"
    prefix = var.prefix
    vpc_cidr_block = var.vpc_cidr_block
}

module "eks-cluster" {
    source = "./modules/eks"
    vpc_id = module.new-vpc.vpc_id
    prefix = var.prefix
    cluster_name = var.cluster_name
    retention_days = var.retention_days
    subnet_ids = module.new-vpc.subnet_ids 
    desired_size = var.desired_size
    max_size = var.max_size
    min_size = var.min_size
}