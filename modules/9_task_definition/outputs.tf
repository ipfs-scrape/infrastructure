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
  }
}
