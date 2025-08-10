resource "aws_efs_file_system" "magento" {
  creation_token = "magento-efs"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "magento-efs"
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "efs-sg"
  description = "Allow NFS from app servers"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_app_nfs" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = var.app_sg_id
  security_group_id        = aws_security_group.efs_sg.id
}

# Mount targets for each private subnet
resource "aws_efs_mount_target" "mounts" {
  count = length(var.private_subnet_ids)

  file_system_id  = aws_efs_file_system.magento.id
  subnet_id       = var.private_subnet_ids[count.index]
  security_groups = [aws_security_group.efs_sg.id]
}
