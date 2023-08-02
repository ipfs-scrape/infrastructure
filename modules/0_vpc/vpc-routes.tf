
###
# Public Routing
###
resource "aws_route_table" "public" {
  for_each = aws_subnet.public
  vpc_id   = aws_vpc.deployment.id

  tags = {
    "Name" = "${var.identifier}-public"
    "AZ"   = each.key
  }
}
# Route Table association for the public subnets
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  route_table_id = aws_route_table.public[each.key].id
  subnet_id      = each.value.id
}

# Route 0.0.0.0/0 to the Internet Gateway
resource "aws_route" "public" {
  for_each               = aws_route_table.public
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

###
# Private Route Table
###
resource "aws_route_table" "private" {
  for_each = aws_subnet.private
  vpc_id   = aws_vpc.deployment.id

  tags = {
    "Name" = "${var.identifier}-private"
    "AZ"   = each.key
  }
}
# Route Table association for the private subnets
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  route_table_id = aws_route_table.private[each.key].id
  subnet_id      = each.value.id
}
# Route 0.0.0.0/0 to the NATs
resource "aws_route" "private" {
  for_each               = aws_nat_gateway.nat
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = each.value.id
}
