provider "aws" {
  region = var.aws_region
}

locals {
  ami_id        = var.ami_id != "" ? var.ami_id : data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type != "" ? var.instance_type : "t2.micro"
}

module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = var.vpc_cidr
  vpc_name    = var.vpc_name
  common_tags = var.common_tags
}

module "subnets" {
  source               = "./modules/subnets"
  vpc_id               = module.vpc.vpc_id
  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  internet_gateway_id  = module.vpc.igw_id
  nat_gateway_id       = module.nat_gateway.nat_gateway_id
  common_tags          = var.common_tags
}

module "nat_gateway" {
  source           = "./modules/nat-gateway"
  public_subnet_id = element(module.subnets.public_subnet_ids, 0)
  vpc_name         = var.vpc_name
  common_tags      = var.common_tags
}

module "security_groups" {
  source      = "./modules/security-groups"
  vpc_id      = module.vpc.vpc_id
  vpc_name    = var.vpc_name
  common_tags = var.common_tags
}

module "alb" {
  source                = "./modules/alb"
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.subnets.public_subnet_ids
  name                  = "${var.vpc_name}-alb"
  common_tags           = var.common_tags
  alb_security_group_id = []
}

module "autoscaling" {
  source                = "./modules/autoscaling"
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.subnets.public_subnet_ids
  alb_security_group_id = module.alb.security_group_id
  app_security_group_id = [module.security_groups.public_sg_id]
  ami_id                = local.ami_id
  instance_type         = local.instance_type
  name                  = "${var.vpc_name}-autoscaling"
  target_group_arns     = [module.alb.target_group_arn]
  common_tags           = var.common_tags
}

module "rds" {
  source                        = "./modules/rds"
  db_name                       = var.db_name
  engine                        = var.engine
  engine_version                = var.engine_version
  instance_class                = var.instance_class
  username                      = var.username
  password                      = var.password
  backup_retention_period       = var.backup_retention_period
  database_security_group_id    = [module.security_groups.private_sg_id]
  vpc_id                        = module.vpc.vpc_id
  subnet_ids                    = module.subnets.private_subnet_ids
  application_security_group_id = module.security_groups.public_sg_id
  multi_az                      = true
  common_tags                   = var.common_tags
}
