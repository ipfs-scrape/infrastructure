
variable "identifier" {
  description = "A unique identifier for the deployment"
  type        = string
}

variable "network" {
  description = "The networking information for the deployment"
  type = object({
    vpc                     = object({ id = string })
    private_subnets         = list(object({ id = string }))
    internal_security_group = object({ id = string })
    ecs_cluster             = object({ id = string })
  })
}


variable "task_definitions" {
  description = "The task definitions to deploy"
  type        = string
}

variable "dynamodb" {
  description = "The DynamoDB configuration for IAMs"
  type = object({
    arn = string
  })
}

variable "load_balancer" {
  description = "The load balancer to attach to the service"
  type = map(object({
    port          = number
    protocol      = string
    path_patterns = list(string)
    listener = object({
      arn = string
    })
  }))

  default = {}
}
