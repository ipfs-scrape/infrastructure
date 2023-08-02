output "listener" {
  value = aws_lb_listener.http_listener
}

output "lb" {
  value = aws_lb.load_balancer
}
