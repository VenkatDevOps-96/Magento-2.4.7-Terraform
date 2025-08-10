output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "varnish_public_ip" {
  value = aws_instance.varnish.public_ip
}

output "varnish_private_ip" {
  value = aws_instance.varnish.private_ip
}

output "admin_private_ip" {
  value = aws_instance.admin.private_ip
}

output "bastion_id" {
  value = aws_instance.bastion.id
}

output "varnish_id" {
  value = aws_instance.varnish.id
}

output "admin_id" {
  value = aws_instance.admin.id
}

