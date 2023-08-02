# infrastructure

the infrastructure

```mermaid
graph TD


```

## deploy the vpc and base ecs resources

```
terraform apply -target module.network
```

## deploy the external lb resources

```
terraform apply -target module.external
```

## deploy the dynamodb resources

```
terraform apply -target module.dynamodb
```

## deploy the ecr registries

```
terraform apply -target aws_ecr_repository.ecr_repository -target aws_ecr_lifecycle_policy.ecr_lifecycle_policy
```

## deploy the fargate services

```
terraform apply -target module.service_definitions -target module.services
```
