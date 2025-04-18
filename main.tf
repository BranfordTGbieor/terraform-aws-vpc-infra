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

module "ec2_public" {
  source                      = "./modules/ec2"
  ami_id                      = local.ami_id
  instance_type               = local.instance_type
  subnet_id                   = element(module.subnets.public_subnet_ids, 0)
  vpc_security_group_ids      = [module.security_groups.public_sg_id]
  associate_public_ip_address = true
  user_data                   = <<EOF
                                #!/bin/bash
                                sudo yum update -y
                                sudo yum install -y httpd
                                sudo systemctl start httpd
                                sudo systemctl enable httpd
                                EOF
  common_tags = merge({
    Name = "${var.vpc_name}-public-instance"
  }, var.common_tags)
}

module "alb" {
  source                = "./modules/alb"
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.subnets.public_subnet_ids
  name                  = "${var.vpc_name}-alb"
  common_tags           = var.common_tags
  alb_security_group_id = [module.security_groups.alb_sg_id]
}

module "autoscaling" {
  source                = "./modules/autoscaling"
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.subnets.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_sg_id
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

resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.vpc.igw_id
  }

  tags = merge({
    Name = "${var.vpc_name}-public-rt"
  }, var.common_tags)
}

resource "aws_route_table_association" "public" {
  count          = length(module.subnets.public_subnet_ids)
  subnet_id      = module.subnets.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = module.nat_gateway.nat_gateway_id
  }

  tags = merge({
    Name = "${var.vpc_name}-private-rt"
  }, var.common_tags)
}

resource "aws_route_table_association" "private" {
  count          = length(module.subnets.private_subnet_ids)
  subnet_id      = module.subnets.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private.id
}
