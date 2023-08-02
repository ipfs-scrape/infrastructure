variable "identifier" {
  description = "A unique identifier for the deployment"
  type        = string
}

# variable "acm" {
#   description = "The acm information for the deployment"
#   type = object({
#     arn = string
#   })
# }

variable "network" {
  description = "The networking information for the deployment"
  type = object({
    vpc                     = object({ id = string })
    public_subnets          = list(object({ id = string }))
    private_subnets         = list(object({ id = string }))
    internal_security_group = object({ id = string })
  })
}
