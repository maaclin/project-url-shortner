variable "execution_policy" {
  description = "The ARN of the policy to attach to the ECS task execution role"
  type        = string
    default     = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

variable "ecr_repo" {
  description = "The name of the ECR repository"
  type        = string
}

variable "table_name" {
  description = "The name of the DynamoDB table for CodeDeploy"
  type        = string
}