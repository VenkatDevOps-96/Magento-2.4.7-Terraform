output "nlb_dns_name" {
  value = aws_lb.internal_nlb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.asg_tg.arn
}

