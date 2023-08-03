
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.identifier}-ecsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy" {
  policy_arn = aws_iam_policy.everything_we_need.arn
  role       = aws_iam_role.ecs_task_role.name
}

resource "aws_iam_policy" "everything_we_need" {
  name        = "${var.identifier}-everything_we_need"
  description = "Allows access to DynamoDB"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:DescribeTable"
        ]
        Effect   = "Allow"
        Resource = var.dynamodb.arn
      },
      {
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
        ]
        Effect   = "Allow"
        Resource = ["*"]
      },
      {
        Action = [
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:CreateLogStream",
        ]
        Effect   = "Allow"
        Resource = ["*"]
      }

    ]
  })
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.identifier}-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_exec" {
  policy_arn = aws_iam_policy.exec.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}

resource "aws_iam_policy" "exec" {
  name        = "${var.identifier}-exec"
  description = "enables start up"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:CreateLogStream",
        ]
        Effect   = "Allow"
        Resource = ["*"]
      }

    ]
  })
}
