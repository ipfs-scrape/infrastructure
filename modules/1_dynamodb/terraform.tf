
# terraform a dynamodb dpeloyment with a private vpc, subnet, security group information coming from var.network
# generate the variable object entry for var.networking
# generate the outputs that a ecs container would need to connect to the dynamodb table
# use the variable indentifier to generate the resource name and anything else that needs to be unique
# configure this for development, using the least expensive options when available


terraform {
  required_version = ">=1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.10.0"
    }
  }
}
