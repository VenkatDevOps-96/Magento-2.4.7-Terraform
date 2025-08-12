resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-server-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.security_group_ids

  # Only include this block if iam_instance_profile is set (optional)
  iam_instance_profile {
    name = var.iam_instance_profile
  }
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.volume_size
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  user_data = var.user_data != "" ? base64encode(var.user_data) : base64encode(templatefile("${path.module}/efs_userdata.sh.tpl", {
  efs_id     = var.efs_id
  aws_region = var.aws_region
 }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "magento-app-server"
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [iam_instance_profile]
  }
}

