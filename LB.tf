resource "aws_lb" "load_balancer" {
  count              = var.feature_flag ? 1 : 0
  name               = "terraform-asg-example"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb_sg[0].id]
}

resource "aws_lb_listener" "http" {
  count             = var.feature_flag ? 1 : 0
  load_balancer_arn = aws_lb.load_balancer[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404 : page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "asg_listener" {
  listener_arn = aws_lb_listener.http[0].arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_tg[0].arn
  }
}

resource "aws_lb_target_group" "asg_tg" {
  count    = var.feature_flag ? 1 : 0
  name     = "targetgroup"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}