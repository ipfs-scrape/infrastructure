## VPC Resources

resource "aws_vpc" "deployment" {
  assign_generated_ipv6_cidr_block = false
  cidr_block                       = var.vpc_cidr
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = {
    "Name" = var.identifier
  }
}

## Subnets

# create a public subnets
resource "aws_subnet" "public" {
  for_each = toset(local.subnets)

  availability_zone       = each.key
  cidr_block              = local.public_subnets[each.key]
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.deployment.id

  tags = {
    "Name" = "${var.identifier}-subnet-public"
    "Type" = "public",
    "AZ"   = each.key
  }

}

# create private subnets 
resource "aws_subnet" "private" {
  for_each = toset(local.subnets)

  availability_zone       = each.key
  cidr_block              = local.private_subnets[each.key]
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.deployment.id

  tags = {
    "Name" = "${var.identifier}-subnet-private"
    "Type" = "private"
    "AZ"   = each.key
  }
}

## Internet Gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.deployment.id

  tags = {
    "Name" = var.identifier
  }
}

resource "aws_eip" "nat" {
  for_each = toset(local.subnets)
}

# Set up NATs
resource "aws_nat_gateway" "nat" {
  for_each          = toset(local.subnets)
  connectivity_type = "public"
  subnet_id         = aws_subnet.public[each.key].id
  allocation_id     = aws_eip.nat[each.key].id

  tags = {
    "Name" = "${var.identifier}-natgw"
    "AZ"   = each.key
  }
}
