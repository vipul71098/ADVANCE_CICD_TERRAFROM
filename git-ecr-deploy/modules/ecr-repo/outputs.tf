output "ecr_repository_urls" {
  description = "URLs of the created ECR repositories"
  value       = [for repo in aws_ecr_repository.repos : repo.repository_url]
}

