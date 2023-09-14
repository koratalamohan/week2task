resource "aws_launch_configuration" "asg_template" {
  count           = var.feature_flag ? 1 : 0
  image_id        = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.sg[0].id]
  user_data       = <<-EOF
              #!/bin/bash
              echo "Hello , wlcome to this page" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "asg_group" {
  count                = var.feature_flag ? 1 : 0
  launch_configuration = aws_launch_configuration.asg_template[0].name
  vpc_zone_identifier  = data.aws_subnets.default.ids

  target_group_arns = [aws_lb_target_group.asg_tg[0].arn]
  health_check_type = "ELB"

  min_size = 2
  max_size = 3

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}