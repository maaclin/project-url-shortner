variable "private_subnets" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "ecs_sg" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "blue_tg" {
  description = "ARN of the blue target group for the ALB"
  type        = string
}
variable "blue_tg_arn" {
  description = "ARN of the blue target group for the ALB"
  type        = string
}

variable "blue_listener" {
  description = "ARN of the HTTP listener for the ALB"
  type        = string
}

variable "execution_role" {
  description = "ARN of the ECS task execution role"
  type        = string
}

variable "task_role" {
  description = "ARN of the ECS task role"
  type        = string
}

variable "ecr_repo" {
  description = "ECR repository URL for the ECS task"
  type        = string
}

variable "email" {
  description = "Email address for notifications"
  type        = string
}