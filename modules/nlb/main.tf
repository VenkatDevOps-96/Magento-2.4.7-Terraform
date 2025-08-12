resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "aws_lb" "internal_nlb" {
  name               = "magento-internal-nlb-${random_string.suffix.result}"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "asg_tg" {
  name        = "asg-tg"
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "instance"
}

# Attach ASG to the NLB target group
resource "aws_autoscaling_attachment" "asg_nlb_attachment" {
  autoscaling_group_name = var.asg_name
  lb_target_group_arn   = aws_lb_target_group.asg_tg.arn
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.internal_nlb.arn
  port              = var.target_group_port
  protocol          = var.target_group_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_tg.arn
  }
}


