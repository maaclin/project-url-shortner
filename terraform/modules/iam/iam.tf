
## Role that ECS for when cluster starts 

resource "aws_iam_role" "ecs_execution_role" {
  name = "${local.name}-ecs-task-execution-role"

  assume_role_policy = local.ecs_role
}

## Execution role able to pull from ECR and write CloudWatch logs 

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  policy_arn = var.execution_policy
  role       = aws_iam_role.ecs_execution_role.name
} 

## App needs to when running to interact with dynamodb table 
resource "aws_iam_role" "ecs_task_role" {
  name = "${local.name}-ecs-task-role"

  assume_role_policy = local.ecs_role
} 
## policies to allow read and write to the table

resource "aws_iam_role_policy" "ecs_task_role_db" {
  role = aws_iam_role.ecs_task_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "dynamodb:GetItem",
        "dynamodb:PutItem"
      ],
      Resource = "arn:aws:dynamodb:eu-west-2:${data.aws_caller_identity.current.account_id}:table/${var.table_name}"
    }]
  })
} 
 
## Role for CodeDeploy to assume when doing deployments

resource "aws_iam_role" "codedeploy" {
  name = "${local.name}-codedeploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      },
    ]
  })
}

## additional policies for ecs

resource "aws_iam_role_policy_attachment" "codedeploy_managed" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

locals {
  name = "ecs-v2"
  region = "eu-west-2"
  ecs_role = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_caller_identity" "current" {}

/// - OIDC for GitHub Actions

resource "aws_iam_openid_connect_provider" "this" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]
}

resource "aws_iam_role" "github_actions_role" {
  name               = "GitHubActionsRole"
  assume_role_policy = data.aws_iam_policy_document.gha_trust_policy.json
}

data "aws_iam_policy_document" "gha_trust_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.this.arn]
    }
    
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:maaclin/project-url-shortner:*"]
    }
  }
}

data "aws_iam_policy_document" "oidc" {
  statement {
    effect = "Allow"
    actions = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "oidc" {
  name   = "GitHubActions-AdminAccess"
  policy = data.aws_iam_policy_document.oidc.json
}

resource "aws_iam_role_policy_attachment" "oidc" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.oidc.arn
}