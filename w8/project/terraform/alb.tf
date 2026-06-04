resource "aws_lb" "main" {
  name               = "${local.environment_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.alb.id]

  enable_deletion_protection = false

  tags = {
    Name = "${local.environment_name}-alb"
  }
}

resource "aws_lb_target_group" "xbrain" {
  name        = "${local.environment_name}-tg"
  port        = var.nodeport
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"
    port                = tostring(var.nodeport)
  }

  tags = {
    Name = "${local.environment_name}-tg"
  }
}

resource "aws_lb_target_group_attachment" "xbrain" {
  target_group_arn = aws_lb_target_group.xbrain.arn
  target_id        = aws_instance.ec2.id
  port             = var.nodeport
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.xbrain.arn
  }
}

output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "ALB DNS name"
}

output "alb_arn" {
  value = aws_lb.main.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.xbrain.arn
}
