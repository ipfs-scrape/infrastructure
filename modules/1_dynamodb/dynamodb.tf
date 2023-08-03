resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = var.network.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [for k, v in var.network.private_route_tables : v.id]
}


resource "aws_dynamodb_table" "dynamodb" {
  name         = var.identifier
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ID"
  attribute {
    name = "ID"
    type = "S"
  }


  tags = {
    Name = var.identifier
  }

}
