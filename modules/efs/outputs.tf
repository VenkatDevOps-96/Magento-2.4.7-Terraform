output "efs_id" {
  value = aws_efs_file_system.magento.id
}

output "efs_dns_name" {
  value = aws_efs_file_system.magento.dns_name
}

output "efs_sg_id" {
  value = aws_security_group.efs_sg.id
}

