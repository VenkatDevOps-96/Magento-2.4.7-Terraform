resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "magento-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "magento-rds-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier             = "magento-db"
  allocated_storage      = 100
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.medium"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.db_sg_id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false
  backup_retention_period = 7

  tags = {
    Name = "magento-mysql-db"
  }
}

