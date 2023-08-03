output "task_definition" {
  value = {
    name  = var.identifier
    image = var.image
    environment = [
      for k, v in var.environment_vars : {
        name  = k
        value = v
      }
    ]
    portMappings = [
      for port in var.ports : {
        containerPort = port
        protocol      = "tcp"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = var.log_group_name
        "awslogs-region"        = var.log_group_region
        "awslogs-stream-prefix" = var.identifier
      }
    }

  }
}
