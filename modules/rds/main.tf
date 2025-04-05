resource "aws_db_subnet_group" "rds_private_subnet_group" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.common_tags
}

resource "aws_db_instance" "primary" {
  identifier              = "${var.db_name}-primary"
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = 20
  storage_type            = "gp2"
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  db_subnet_group_name    = aws_db_subnet_group.rds_private_subnet_group.name
  vpc_security_group_ids  = var.database_security_group_id
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = true
  multi_az                = true

  tags = merge({
    Name = "${var.db_name}-primary"
  }, var.common_tags)
}

resource "aws_db_instance" "replica" {
  identifier          = "${var.db_name}-replica"
  replicate_source_db = aws_db_instance.primary.identifier
  instance_class      = var.instance_class
  skip_final_snapshot = true

  tags = merge({
    Name = "${var.db_name}-replica"
  }, var.common_tags)
}