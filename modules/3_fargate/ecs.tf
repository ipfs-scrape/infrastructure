resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = var.identifier
  container_definitions    = var.task_definitions
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

}

resource "aws_ecs_service" "my_service" {
  name            = var.identifier
  cluster         = var.network.ecs_cluster.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = var.desired_count

  network_configuration {
    security_groups = [var.network.internal_security_group.id]
    subnets         = var.network.private_subnets[*].id
  }

  dynamic "load_balancer" {
    for_each = var.load_balancer
    iterator = each
    content {
      target_group_arn = aws_lb_target_group.ecs[each.key].arn
      container_name   = var.identifier
      container_port   = aws_lb_target_group.ecs[each.key].port
    }
  }

  lifecycle {
    ignore_changes = [
      capacity_provider_strategy,
    ]
  }
}

