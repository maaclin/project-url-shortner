locals {
  name = "ecs-v2"
  region = "eu-west-2"
}

// 2 - ECS Module

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${local.name}-cluster"
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${local.name}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.ecs_sg]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.blue_tg_arn
    container_name   = local.name
    container_port   = "8080"
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  # ignore changes in image ID outside Terraform, i.e. in GitHub actions

  lifecycle {
    ignore_changes = [task_definition]
  }

  depends_on = [var.blue_listener]
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${local.name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role
  task_role_arn            = var.task_role

  container_definitions = jsonencode([
    {
      name      = local.name
      image     = "${var.ecr_repo}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "TABLE_NAME"
          value = aws_dynamodb_table.url.name
        }
      ]
      ## connected to log group
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = local.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

/// DynamoDB Table ///

resource "aws_dynamodb_table" "url" {
  name         = local.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
  point_in_time_recovery {
    enabled = true
  }

  lifecycle {
    ignore_changes = all
  }

  tags = { Name = "${local.name}-db-table" }

}

// CloudWatch /// 

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${local.name}"
  retention_in_days = 7
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "high_cpu_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Triggered when CPU utilization exceeds 80%"

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "memory_alarm" {
  alarm_name          = "high_memory_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Triggered when CPU utilization exceeds 80%"

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_sns_topic" "alerts" {
  name = "ecs_alerts"
}

resource "aws_sns_topic_subscription" "cpu_alert" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.email
}

## CloudWatch alarm monitors CPU and memory  on the cluster and triggers alarm > 80% for 2 periods of 60 seconds. 
## The alarm sends a notification to an SNS topic configured to send email alerts.

resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  dashboard_name = "ECS-Dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric",
        x      = 0,
        y      = 0,
        width  = 6,
        height = 6,
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", aws_ecs_cluster.ecs_cluster.name],
            ["AWS/ECS", "MemoryUtilization", "ClusterName", aws_ecs_cluster.ecs_cluster.name],
            
          ]
          title   = "ECS Cluster CPU and Memory Utilization"
          view    = "timeSeries"
          stacked = false
          region  = "eu-west-2"
          period  = 300
          stat    = "Average"
        }
      }
    ]
  })
}
