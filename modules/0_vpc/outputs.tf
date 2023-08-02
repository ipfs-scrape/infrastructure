output "private_subnets" {
  value = [for k, v in aws_subnet.private : v]
}

output "public_subnets" {
  value = [for k, v in aws_subnet.public : v]
}

output "vpc" {
  value = aws_vpc.deployment
}

output "internal_security_group" {
  value = aws_security_group.internal
}


output "ecs_cluster" {
  value = aws_ecs_cluster.cluster
}

output "log_group" {
  value = aws_cloudwatch_log_group.cluster
}

output "private_route_tables" {
  value = [for k, v in aws_route_table.private : v]
}
