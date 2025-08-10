resource "aws_lb" "app_alb" {
  name               = "magento-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnets
}

# --- Target Group: Varnish ---
resource "aws_lb_target_group" "varnish_tg" {
  name        = "varnish-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_target_group_attachment" "varnish" {
  target_group_arn = aws_lb_target_group.varnish_tg.arn
  target_id        = var.varnish_target_ip
  port             = 80
}

# --- Target Group: Admin ---
resource "aws_lb_target_group" "admin_tg" {
  name        = "admin-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_target_group_attachment" "admin" {
  target_group_arn = aws_lb_target_group.admin_tg.arn
  target_id        = var.admin_target_ip
  port             = 8080
}

# --- Listener ---
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.varnish_tg.arn
  }
}

# --- Rule for /admin ---
resource "aws_lb_listener_rule" "admin" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.admin_tg.arn
  }

  condition {
    path_pattern {
      values = ["*/admin"]
    }
  }
}

