output "ecr_repository_urls" {
  description = "URLs of the created ECR repositories"
  value       = module.ecr-repo.ecr_repository_urls
}
