resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.bastion_instance_type
  subnet_id              = var.bastion_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name = "bastion"
  }
}

resource "aws_instance" "varnish" {
  ami                    = var.ami_id
  instance_type          = var.varnish_instance_type
  subnet_id              = var.varnish_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids

  root_block_device {
    volume_size = var.varnish_volume_size
    volume_type = "gp2"
  }

  tags = {
    Name = "varnish"
  }
}

resource "aws_instance" "admin" {
  ami                    = var.admin_ami_id
  instance_type          = "t3.medium"
  key_name               = var.key_name
  subnet_id              = var.admin_subnet_id
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name = "magento-admin-server"
  }
}

