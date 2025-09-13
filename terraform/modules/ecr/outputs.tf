
output "ecr_repo" {
  description = "URL of the ECR repository"
  value       = data.aws_ecr_repository.url.repository_url
}