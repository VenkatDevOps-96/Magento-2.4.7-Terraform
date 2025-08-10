resource "aws_autoscaling_group" "app_asg" {
  name                      = "magento-app-asg"
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = var.health_check_type
  health_check_grace_period = 300

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  target_group_arns = var.target_group_arns

  tag {
    key                 = "Name"
    value               = "magento-app-server"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

