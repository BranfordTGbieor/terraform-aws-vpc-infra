resource "aws_launch_template" "app_template" {
  name_prefix   = "${var.name}-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    security_groups = var.app_security_group_id
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge({
      Name = var.name
    }, var.common_tags)
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                = var.name
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = var.target_group_arns

  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
}