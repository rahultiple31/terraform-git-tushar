resource "aws_launch_template" "this" {
  name_prefix   = var.lt_name
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    security_groups = var.security_groups
  }

  user_data = base64encode(var.user_data)
}

resource "aws_autoscaling_group" "this" {
  name                = var.asg_name
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.subnets

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]
}
