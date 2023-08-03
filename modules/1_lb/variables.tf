variable "identifier" {
  description = "A unique identifier for the deployment"
  type        = string
}

variable "network" {
  description = "The networking information for the deployment"
  type = object({
    vpc                     = object({ id = string })
    public_subnets          = list(object({ id = string }))
    private_subnets         = list(object({ id = string }))
    internal_security_group = object({ id = string })
  })
}

variable "edge_ips" {
  description = "the ips/cidrs to let in"
  type        = list(string)
}
