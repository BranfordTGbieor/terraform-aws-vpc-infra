resource "aws_eip" "nat_eip" {
  vpc = true

  tags = merge({
    Name = "${var.vpc_name}-nat-eip"
  }, var.common_tags)
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_id

  tags = merge({
    Name = "${var.vpc_name}-nat-gateway"
  }, var.common_tags)
}
