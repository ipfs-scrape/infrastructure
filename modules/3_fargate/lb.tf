/*
    This module creates an AWS Application Load Balancer target group and listener rule for ECS services.

    The target group is created with the specified name, port, protocol, VPC ID, load balancing algorithm type, target type, and health check settings.

    The listener rule is created with the specified listener ARN, path patterns, and host header values. It forwards traffic to the target group.
*/

resource "aws_lb_target_group" "ecs" {
  for_each = var.load_balancer

  name     = each.key
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = var.network.vpc.id

  load_balancing_algorithm_type = "least_outstanding_requests"
  target_type                   = "ip"

  health_check {
    path                = "/"
    protocol            = each.value.protocol
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  tags = {
    Name = each.key
  }
}

resource "aws_lb_listener_rule" "ecs" {
  for_each = var.load_balancer

  listener_arn = each.value.listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs[each.key].arn
  }

  condition {
    path_pattern {
      values = try(each.value.path_patterns, ["/*"])
    }
  }

  #   condition {
  #     host_header {
  #       values = each.value.host_header
  #     }
  #   }
}
