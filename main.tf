data "aws_region" "current" {}
locals {
  identifier = "ipfs-dev"
  services = {
    worker = {
      image         = "ghcr.io/ipfs-scrape/worker:latest"
      desired_count = 1
      environment_vars = {
        AWS_REGION              = data.aws_region.current.name
        GIN_MODE                = "release"
        IPFS_DYNAMODB_NAME      = module.dynamodb.name
        IPFS_GATEWAY_URL        = "https://blockpartyplatform.mypinata.cloud/ipfs"
        IPFS_SCRAPE_INTERVAL    = "1s"
        IPFS_SCRAPE_CONCURRENCY = "2"
      }
    }
    api = {
      image         = "ghcr.io/ipfs-scrape/api:latest"
      port          = 8080
      protocol      = "HTTP"
      path_patterns = ["/*"]
      desired_count = 2
      environment_vars = {
        GIN_MODE           = "release"
        AWS_REGION         = data.aws_region.current.name
        IPFS_DYNAMODB_NAME = module.dynamodb.name
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

  network  = module.network
  edge_ips = ["0.0.0.0/0"]
}

module "service_definitions" {
  for_each   = local.services
  source     = "./modules/9_task_definition"
  identifier = "${local.identifier}-${each.key}"

  image = each.value.image

  ports            = try([each.value.port], [])
  environment_vars = try(each.value.environment_vars, {})

  log_group_name   = module.network.log_group.name
  log_group_region = data.aws_region.current.name

}

module "services" {
  for_each   = local.services
  source     = "./modules/3_fargate"
  identifier = "${local.identifier}-${each.key}"

  network          = module.network
  dynamodb         = module.dynamodb
  task_definitions = jsonencode([module.service_definitions[each.key].task_definition])
  desired_count    = each.value.desired_count
  load_balancer = try(
    {
      "${each.key}-${each.value.port}" = merge(each.value, {
        listener = module.edge.listener
      })
    }
  , {})
}
