variable "identifier" {
  description = "value of the identifier"
  type        = string
}

variable "image" {
  description = "value of the image"
  type        = string
}

variable "environment_vars" {
  description = "key value environment_vars"
  type        = map(string)
  default     = {}
}

variable "ports" {
  description = "list of ports"
  type        = list(number)
  default     = []
}
