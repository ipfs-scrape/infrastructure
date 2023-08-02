data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

locals {
  cidr_public  = cidrsubnet(var.vpc_cidr, 4, 0)
  cidr_private = cidrsubnet(var.vpc_cidr, 4, 1)
  subnet_count = 2

  subnets = slice(data.aws_availability_zones.available.names, 0, local.subnet_count)

  private_subnets = {
    for i, subnet in local.subnets : subnet => cidrsubnet(local.cidr_private, 4, i)
  }

  public_subnets = {
    for i, subnet in local.subnets : subnet => cidrsubnet(local.cidr_public, 4, i)
  }
}
