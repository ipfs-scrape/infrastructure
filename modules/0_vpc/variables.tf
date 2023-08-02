variable "identifier" {
  type        = string
  description = "A unique identifier for the deployment"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "172.31.0.0/16"
}
