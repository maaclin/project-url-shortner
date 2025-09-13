
output "ecr_repo" {
  description = "URI of the ECR repository"
  value       = aws_ecr_repository.url.repository_url
}