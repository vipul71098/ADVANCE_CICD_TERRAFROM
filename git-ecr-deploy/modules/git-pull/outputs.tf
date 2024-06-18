output "repo_directories" {
  description = "Directories of the cloned Git repositories"
  value       = [for repo in null_resource.git_pull : "${path.module}/repos/${basename(var.repo_urls[index(var.repo_urls, repo.triggers.repo_url)])}"]
}

