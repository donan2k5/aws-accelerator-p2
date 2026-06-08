data "aws_caller_identity" "current" {}

module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security_groups" {
  source = "./modules/security_groups"

  project_name = var.project_name
  env          = var.env
  vpc_id       = module.vpc.vpc_id
}

module "ec2" {
  source = "./modules/ec2"

  project_name     = var.project_name
  env              = var.env
  instance_type    = var.instance_type
  public_subnet_id = module.vpc.public_subnet_ids[0]
  ec2_sg_id        = module.security_groups.ec2_sg_id
  key_pair_name    = var.key_pair_name
}

module "rds" {
  source = "./modules/rds"

  project_name       = var.project_name
  env                = var.env
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  db_instance_class  = var.db_instance_class
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security_groups.rds_sg_id
}

module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  env          = var.env
  account_id   = data.aws_caller_identity.current.account_id
}
