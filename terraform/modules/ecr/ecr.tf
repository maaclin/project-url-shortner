locals {
  name = "ecs-v2"
  region = "eu-west-2"
}

data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "url" {
  name = var.ecr_repo
}

resource "aws_ecr_repository_policy" "ecr" {
  repository = aws_ecr_repository.url.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid    = "AllowPull",
      Effect = "Allow",
      Principal = {
        AWS = [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.name}-ecs-task-execution-role",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        ]
      },
      Action = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:InitiateLayerUpload",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetAuthorizationToken",
        "ecr:DescribeRepositories",
        "ecr:PutImage"      ]
      }
    ]
  })
}