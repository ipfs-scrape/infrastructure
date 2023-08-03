resource "aws_lb" "load_balancer" {
  name               = var.identifier
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.network.internal_security_group.id, aws_security_group.edge.id]
  subnets            = var.network.public_subnets[*].id

  tags = {
    Name = var.identifier
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}


