resource "aws_instance" "public_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = var.user_data
  tags                        = var.common_tags
}