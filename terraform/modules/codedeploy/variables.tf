variable "codedeploy_role" {
  description = "ARN of the CodeDeploy role"
  type        = string
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_service" {
  description = "Name of the ECS service"
  type        = string
}

variable "blue_https_listener" {
  description = "ARN of the blue HTTPS listener"
  type        = string
}

variable "green_test_listener" {
  description = "ARN of the blue HTTPS listener"
  type        = string
}

variable "blue_tg_name" {
  description = "name of the blue target group"
  type        = string
}

variable "green_tg_name" {
  description = "name of the green target group"
  type        = string
}


