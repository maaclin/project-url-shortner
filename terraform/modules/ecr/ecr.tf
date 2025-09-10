
resource "aws_ecr_repository" "url" {
  name = "projects/url-shortner-repo"
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
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.name}-ecs-task-execution-role"
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
        "ecr:PutImage"
      ]
      }
    ]
  })
}