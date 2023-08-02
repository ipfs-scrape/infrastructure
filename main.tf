locals {
  identifier = "ipfs-dev"
  services = {
    worker = {
      environment_vars = {
        DYNMANODB_NAME = module.dynamodb.name
      }
    }
    api = {
      port          = 7654
      protocol      = "HTTP"
      path_patterns = ["/api/v0/"]
      environment_vars = {
        DYNMANODB_NAME = module.dynamodb.name
      }
    }
  }
}

module "network" {
  source     = "./modules/0_vpc"
  identifier = local.identifier
}

moved {
  from = module.network.aws_vpc_endpoint.dynamodb
  to   = module.dynamodb.aws_vpc_endpoint.dynamodb
}

module "dynamodb" {
  source     = "./modules/1_dynamodb"
  identifier = local.identifier

  network = module.network
}

module "edge" {
  source     = "./modules/1_lb"
  identifier = local.identifier

  network = module.network
}

module "service_definitions" {
  for_each   = local.services
  source     = "./modules/9_task_definition"
  identifier = "${local.identifier}-${each.key}"

  image = "${aws_ecr_repository.ecr_repository[each.key].repository_url}:latest"

  ports            = try([each.value.port], [])
  environment_vars = try(each.value.environment_vars, {})

}

module "services" {
  for_each   = local.services
  source     = "./modules/3_fargate"
  identifier = "${local.identifier}-${each.key}"

  network          = module.network
  dynamodb         = module.dynamodb
  task_definitions = jsonencode([module.service_definitions[each.key].task_definition])

  load_balancer = try(
    {
      "${each.key}-${each.value.port}" = merge(each.value, {
        listener = module.edge.listener
      })
    }
  , {})
}
