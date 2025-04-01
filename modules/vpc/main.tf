resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge({
    Name = var.vpc_name
  }, var.common_tags)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = merge({
    Name = "${var.vpc_name}-igw"
  }, var.common_tags)
}
