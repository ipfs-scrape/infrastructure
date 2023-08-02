
resource "aws_ecr_repository" "ecr_repository" {
  for_each = local.services
  name     = each.key
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_policy" {
  for_each = local.services

  repository = aws_ecr_repository.ecr_repository[each.key].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire images older than 14 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 14
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
